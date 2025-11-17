namespace :shrine do
  desc "Clear ALL cached files (Development only)"
  task clear_all_cache: :environment do
    if Rails.env.development?
      cache_dir = Rails.root.join("public/uploads/cache")

      if Dir.exist?(cache_dir)
        deleted_count = 0
        Dir.glob(File.join(cache_dir, "**/*")).each do |file_path|
          if File.file?(file_path)
            File.delete(file_path)
            deleted_count += 1
            puts "Deleted: #{file_path}"
          end
        end

        # 空のディレクトリも削除
        Dir.glob(File.join(cache_dir, "**/")).reverse_each do |dir_path|
          if Dir.empty?(dir_path)
            Dir.rmdir(dir_path)
            puts "Removed empty directory: #{dir_path}"
          end
        end

        puts "All cache files cleared! Deleted #{deleted_count} files."
      else
        puts "Cache directory not found"
      end
    else
      puts "This task can only be run in development environment"
    end
  end
  desc "Clear orphaned store files (Development only)"
  task clear_orphaned_store: :environment do
    if Rails.env.development?
      store_dir = Rails.root.join("public/uploads")

      puts "Starting orphaned store files cleanup..."
      puts "Store directory: #{store_dir}"

      if Dir.exist?(store_dir)
        # データベースで参照されているファイル名を取得
        referenced_files = []

        # 各モデルのShrineアップローダーを確認
        # あなたのアプリに合わせてモデル名とフィールド名を調整してください

        # 例：Userモデルのavatarフィールドがある場合
        if defined?(User)
          User.find_each do |user|
            if user.avatar_data.present?
              begin
                avatar_data = JSON.parse(user.avatar_data)
                referenced_files << avatar_data["id"] if avatar_data["id"]
              rescue JSON::ParserError
                # JSONパースエラーは無視
              end
            end
          end
        end

        # 例：Postモデルのimageフィールドがある場合
        if defined?(Post)
          Post.find_each do |post|
            if post.image_data.present?
              begin
                image_data = JSON.parse(post.image_data)
                referenced_files << image_data["id"] if image_data["id"]
              rescue JSON::ParserError
                # JSONパースエラーは無視
              end
            end
          end
        end

        puts "Referenced files in database: #{referenced_files.count}"

        deleted_count = 0
        kept_count = 0

        # public/uploads直下のファイルをチェック（cacheディレクトリは除外）
        Dir.glob(File.join(store_dir, "*")).each do |file_path|
          next if File.directory?(file_path) # ディレクトリはスキップ
          next if File.basename(file_path) == "cache" # cacheディレクトリはスキップ

          file_name = File.basename(file_path, ".*") # 拡張子なしのファイル名

          # データベースで参照されていないファイルを削除
          unless referenced_files.include?(file_name)
            File.delete(file_path)
            deleted_count += 1
            puts "✓ Deleted orphaned file: #{File.basename(file_path)}"
          else
            kept_count += 1
            puts "○ Kept referenced file: #{File.basename(file_path)}"
          end
        end

        puts "Orphaned store files cleanup completed!"
        puts "Deleted: #{deleted_count} files, Kept: #{kept_count} files"
      else
        puts "Store directory not found"
      end
    else
      puts "This task can only be run in development environment"
    end
  end

  # 🆕 すべての本体ファイルを強制削除（開発環境用）
  desc "Clear ALL store files (Development only - DANGER)"
  task clear_all_store: :environment do
    if Rails.env.development?
      store_dir = Rails.root.join("public/uploads")

      puts "⚠️  WARNING: This will delete ALL files in public/uploads (except cache directory)"
      puts "Store directory: #{store_dir}"

      if Dir.exist?(store_dir)
        deleted_count = 0

        Dir.glob(File.join(store_dir, "*")).each do |file_path|
          next if File.directory?(file_path) # ディレクトリはスキップ
          next if File.basename(file_path) == "cache" # cacheディレクトリはスキップ

          if File.file?(file_path)
            File.delete(file_path)
            deleted_count += 1
            puts "✓ Deleted: #{File.basename(file_path)}"
          end
        end

        puts "All store files cleared! Deleted #{deleted_count} files."
      else
        puts "Store directory not found"
      end
    else
      puts "This task can only be run in development environment"
    end
  end

  # 🆕 キャッシュと本体両方をまとめて削除
  desc "Clear both cache and store files (Development only)"
  task clear_all: :environment do
    if Rails.env.development?
      puts "🧹 Starting complete cleanup..."

      Rake::Task["shrine:clear_all_cache"].invoke
      puts ""
      Rake::Task["shrine:clear_all_store"].invoke

      puts ""
      puts "🎉 Complete cleanup finished!"
    else
      puts "This task can only be run in development environment"
    end
  end
end
