mysql_service 'default' do
  #version '5.7'
  initial_root_password 'vagrant'
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end


# MySQL用のプロバイダー
mysql2_chef_gem 'default' do
  action :install
end

# MySQL接続情報
mysql_connection_info ={
  host: 'localhost',
  username: 'root',
  socket: '/var/run/mysql-default/mysqld.sock',
  password: 'vagrant'
}


# データベース作成
mysql_database 'freeciv_web' do
  connection mysql_connection_info
  action :create
end

# 一般ユーザー追加
mysql_database_user 'freeciv_web_user' do
  connection mysql_connection_info
  password 'freeciv_web_user_vagrant'
  # 権限はレコードの参照, 更新, 挿入, 削除のみ
  privileges [:select, :update, :insert, :delete]
  action [:create, :grant]
end

