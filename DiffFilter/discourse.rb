31458
length: 75
length: 75
length: 75
length: 12
length: 12
length: 12
length: 12
length: 12
length: 12
length: 12
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 20
length: 20
length: 20
length: 14
length: 31
length: 17
length: 913
length: 933
length: 20
length: 913
length: 913
length: 913
length: 20
length: 19
length: 19
length: 19
length: 19
length: 19
length: 15
length: 15
length: 15
length: 15
length: 15
length: 15
length: 12
length: 12
length: 12
i 1000 length: 11
length: 11
length: 15
length: 11
length: 22
length: 20
length: 20
length: 20
length: 16
length: 14
length: 15
length: 15
length: 15
length: 18
length: 18
length: 18
length: 279
hit line +    change_column :facebook_user_infos, :facebook_user_id, :integer, limit: 8, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 36a069488ea2d981fef3590e6e773c4d777f78f2 5dfb04e4b31b4961c02ee7e5aa3fa2110fdc7255 db/migrate/*
version: 36a069488ea2d981fef3590e6e773c4d777f78f2 vs 5dfb04e4b31b4961c02ee7e5aa3fa2110fdc7255
filename: diff --git a/db/migrate/20130205021905_alter_facebook_user_id.rb b/db/migrate/20130205021905_alter_facebook_user_id.rb
con: diff --git a/db/migrate/20130205021905_alter_facebook_user_id.rb b/db/migrate/20130205021905_alter_facebook_user_id.rb
index 4072995418..8517a9799e 100644
--- a/db/migrate/20130205021905_alter_facebook_user_id.rb
+++ b/db/migrate/20130205021905_alter_facebook_user_id.rb
@@ -1,6 +1,6 @@
 class AlterFacebookUserId < ActiveRecord::Migration
   def up
-    change_column :facebook_user_infos, :facebook_user_id, :integer, :limit => 8, null: false
+    change_column :facebook_user_infos, :facebook_user_id, :integer, limit: 8, null: false
   end
 
   def down
length: 11
length: 15
length: 30
length: 15
length: 15
length: 15
length: 16
length: 76
length: 92
length: 92
length: 24
length: 21
length: 16
length: 16
length: 16
length: 31
length: 15
length: 11
length: 11
length: 11
length: 24
length: 46
length: 46
length: 17
length: 11
length: 11
length: 11
length: 11
length: 11
length: 17
i 2000 length: 24
length: 20
length: 61
length: 11
length: 28
length: 12
length: 11
length: 11
length: 11
length: 11
length: 11
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 50
length: 50
length: 25
length: 25
length: 50
length: 75
length: 12
length: 12
length: 12
length: 37
length: 37
length: 25
length: 62
length: 62
length: 11
length: 11
length: 11
length: 11
length: 22
length: 22
length: 22
length: 22
length: 11
length: 11
length: 11
length: 18
length: 18
length: 18
length: 12
length: 12
length: 43
length: 43
length: 11
length: 11
length: 52
length: 52
length: 43
length: 15
length: 12
length: 23
length: 12
length: 51
length: 72
length: 72
length: 72
length: 21
length: 33
length: 11
length: 95
length: 43
length: 138
length: 21
length: 13
length: 15
length: 15
i 3000 length: 15
length: 11
length: 11
length: 11
length: 11
length: 11
length: 21
length: 11
length: 59
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff b2d300fe0b81dd74efe57250855a4ee472f3a1e6 2e478d8537de717595193b5534476c131fc83e19 db/migrate/*
version: b2d300fe0b81dd74efe57250855a4ee472f3a1e6 vs 2e478d8537de717595193b5534476c131fc83e19
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 28
length: 87
length: 55
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 3d75e69bd571ec0e6ba35b363668886b29ef8a7c 3af12ba7d38dd46f0c475179c3325635c17e85e4 db/migrate/*
version: 3d75e69bd571ec0e6ba35b363668886b29ef8a7c vs 3af12ba7d38dd46f0c475179c3325635c17e85e4
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 98
length: 98
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 6dc5659fed2995da1c9ab2c98f3dab03c5c4aa7d 1323a717da416a3c9472f0c78e976b6eec74362a db/migrate/*
version: 6dc5659fed2995da1c9ab2c98f3dab03c5c4aa7d vs 1323a717da416a3c9472f0c78e976b6eec74362a
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 12
length: 98
length: 98
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 7efe97798b083b995f2c2ac390137853995aaaed 61b387524d4f882b5c4be7a5000973d544def91a db/migrate/*
version: 7efe97798b083b995f2c2ac390137853995aaaed vs 61b387524d4f882b5c4be7a5000973d544def91a
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 98
length: 98
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 635ec382223bd9af6a086796b992200ef51450bd 5df9370ebe6079368aa4a2dffd5a2e98877dbb71 db/migrate/*
version: 635ec382223bd9af6a086796b992200ef51450bd vs 5df9370ebe6079368aa4a2dffd5a2e98877dbb71
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 16
length: 16
length: 16
length: 37
length: 37
length: 16
length: 16
length: 16
length: 16
length: 114
length: 114
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff d51a3cf50f4f0ccc6d617c592732817361dee70c 013ad0fdda04f24088d0990871074736e1dc60b9 db/migrate/*
version: d51a3cf50f4f0ccc6d617c592732817361dee70c vs 013ad0fdda04f24088d0990871074736e1dc60b9
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 114
length: 114
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 171e703e1142f6e0a0f0efaf90541d179a2c63fd 21bfb64a2808b23711e90d4efa7bd9abe0c1ed4c db/migrate/*
version: 171e703e1142f6e0a0f0efaf90541d179a2c63fd vs 21bfb64a2808b23711e90d4efa7bd9abe0c1ed4c
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 37
length: 37
length: 37
length: 37
length: 37
length: 14
length: 14
length: 14
length: 51
length: 51
length: 11
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 15
length: 15
length: 15
length: 209
length: 209
hit line +    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
results: 1
hit line +    change_column table, :ip_address, :inet, { :null => false }
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff d7d3be1130c665cc7fab9f05dbf32335229137a6 d25d1f777cc1cbeb000c2e7dc46c69ca7255995e db/migrate/*
version: d7d3be1130c665cc7fab9f05dbf32335229137a6 vs d25d1f777cc1cbeb000c2e7dc46c69ca7255995e
filename: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
con: diff --git a/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
new file mode 100644
index 0000000000..a0c3924bfd
--- /dev/null
+++ b/db/migrate/20130624203206_change_ip_to_inet_in_topic_link_clicks.rb
@@ -0,0 +1,21 @@
+require 'ipaddr'
+
+class ChangeIpToInetInTopicLinkClicks < ActiveRecord::Migration
+  def up
+    add_column :topic_link_clicks, :ip_address, :inet
+
+    execute "UPDATE topic_link_clicks SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column :topic_link_clicks, :ip_address, :inet, { :null => false }
+    remove_column :topic_link_clicks, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
con: diff --git a/db/migrate/20130625022454_change_ip_to_inet_in_views.rb b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
new file mode 100644
index 0000000000..30a0e8390b
--- /dev/null
+++ b/db/migrate/20130625022454_change_ip_to_inet_in_views.rb
@@ -0,0 +1,22 @@
+require 'ipaddr'
+
+class ChangeIpToInetInViews < ActiveRecord::Migration
+  def up
+    table = :views
+    add_column table, :ip_address, :inet
+
+    execute "UPDATE views SET ip_address = inet(
+      (ip >> 24 & 255) || '.' ||
+      (ip >> 16 & 255) || '.' ||
+      (ip >>  8 & 255) || '.' ||
+      (ip >>  0 & 255)
+    );"
+
+    change_column table, :ip_address, :inet, { :null => false }
+    remove_column table, :ip
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 17
length: 18
length: 13
length: 143
length: 143
length: 12
length: 12
length: 28
length: 40
length: 28
length: 44
length: 13
length: 13
length: 13
length: 57
length: 88
length: 88
length: 11
length: 20
length: 13
length: 13
length: 31
length: 31
length: 31
i 4000 length: 20
length: 20
length: 20
length: 20
length: 20
length: 20
length: 20
length: 13
length: 11
length: 12
length: 56
length: 56
length: 18
length: 74
length: 74
length: 21
length: 95
length: 95
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 120
length: 120
length: 25
length: 25
length: 18
length: 15
length: 58
length: 58
hit line +    change_column :posts, :user_id, :integer, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 80c4e0233529954ccc5fd2a85c8458982b6ca833 73711bc4b85e8914c6b110d5c9bb3805ca7c432c db/migrate/*
version: 80c4e0233529954ccc5fd2a85c8458982b6ca833 vs 73711bc4b85e8914c6b110d5c9bb3805ca7c432c
filename: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
con: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
new file mode 100644
index 0000000000..8a9141268d
--- /dev/null
+++ b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
@@ -0,0 +1,12 @@
+class AllowNullUserIdOnPosts < ActiveRecord::Migration
+  def up
+    change_column :posts, :user_id, :integer, null: true
+    execute "UPDATE posts SET user_id = NULL WHERE nuked_user = true"
+    remove_column :posts, :nuked_user
+  end
+
+  def down
+    add_column    :posts, :nuked_user, :boolean, default: false
+    change_column :posts, :user_id, :integer, null: false
+  end
+end
length: 58
length: 58
hit line +    change_column :posts, :user_id, :integer, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff b8493b024bf46ca525898c63c2c9ce1db2d2a49f 2d6759d5a02feff6d55c075928d3c04fdf410146 db/migrate/*
version: b8493b024bf46ca525898c63c2c9ce1db2d2a49f vs 2d6759d5a02feff6d55c075928d3c04fdf410146
filename: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
con: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
new file mode 100644
index 0000000000..8a9141268d
--- /dev/null
+++ b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
@@ -0,0 +1,12 @@
+class AllowNullUserIdOnPosts < ActiveRecord::Migration
+  def up
+    change_column :posts, :user_id, :integer, null: true
+    execute "UPDATE posts SET user_id = NULL WHERE nuked_user = true"
+    remove_column :posts, :nuked_user
+  end
+
+  def down
+    add_column    :posts, :nuked_user, :boolean, default: false
+    change_column :posts, :user_id, :integer, null: false
+  end
+end
length: 15
length: 11
length: 179
length: 179
hit line +    change_column :posts, :user_id, :integer, null: false
results: 1
hit line +    change_column :topics, :user_id, :integer, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 379007de6c1a85eaa59026ad5c6a6b4050729087 c59c2a4bb3a2f0e1aa47fbb16a68d81a4e01eb63 db/migrate/*
version: 379007de6c1a85eaa59026ad5c6a6b4050729087 vs c59c2a4bb3a2f0e1aa47fbb16a68d81a4e01eb63
filename: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
con: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
new file mode 100644
index 0000000000..8a9141268d
--- /dev/null
+++ b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
@@ -0,0 +1,12 @@
+class AllowNullUserIdOnPosts < ActiveRecord::Migration
+  def up
+    change_column :posts, :user_id, :integer, null: true
+    execute "UPDATE posts SET user_id = NULL WHERE nuked_user = true"
+    remove_column :posts, :nuked_user
+  end
+
+  def down
+    add_column    :posts, :nuked_user, :boolean, default: false
+    change_column :posts, :user_id, :integer, null: false
+  end
+end
filename: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
con: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
new file mode 100644
index 0000000000..48e9b157d5
--- /dev/null
+++ b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
@@ -0,0 +1,9 @@
+class AllowNullUserIdOnTopics < ActiveRecord::Migration
+  def up
+    change_column :topics, :user_id, :integer, null: true
+  end
+
+  def down
+    change_column :topics, :user_id, :integer, null: false
+  end
+end
length: 14
length: 23
length: 23
length: 23
length: 21
length: 16
length: 60
length: 60
length: 74
length: 74
length: 60
length: 60
length: 13
length: 13
length: 13
length: 11
length: 277
length: 277
hit line +    change_column :posts, :user_id, :integer, null: false
results: 1
hit line +    change_column :topics, :user_id, :integer, null: false
results: 2
hit line +    change_column :user_histories, :acting_user_id, :integer, :null => false
results: 3
cmd cd /Users/jwy/Research/discourse2/; git diff b7c0b3a3ca20a6d76079a7a2e56abd3f365c9949 bbfcec8d187809af8fba8aaffc958a525d51f487 db/migrate/*
version: b7c0b3a3ca20a6d76079a7a2e56abd3f365c9949 vs bbfcec8d187809af8fba8aaffc958a525d51f487
filename: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
con: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
new file mode 100644
index 0000000000..8a9141268d
--- /dev/null
+++ b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
@@ -0,0 +1,12 @@
+class AllowNullUserIdOnPosts < ActiveRecord::Migration
+  def up
+    change_column :posts, :user_id, :integer, null: true
+    execute "UPDATE posts SET user_id = NULL WHERE nuked_user = true"
+    remove_column :posts, :nuked_user
+  end
+
+  def down
+    add_column    :posts, :nuked_user, :boolean, default: false
+    change_column :posts, :user_id, :integer, null: false
+  end
+end
filename: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
con: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
new file mode 100644
index 0000000000..48e9b157d5
--- /dev/null
+++ b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
@@ -0,0 +1,9 @@
+class AllowNullUserIdOnTopics < ActiveRecord::Migration
+  def up
+    change_column :topics, :user_id, :integer, null: true
+  end
+
+  def down
+    change_column :topics, :user_id, :integer, null: false
+  end
+end
filename: diff --git a/db/migrate/20130912185218_acting_user_null.rb b/db/migrate/20130912185218_acting_user_null.rb
con: diff --git a/db/migrate/20130912185218_acting_user_null.rb b/db/migrate/20130912185218_acting_user_null.rb
new file mode 100644
index 0000000000..fe99e3783c
--- /dev/null
+++ b/db/migrate/20130912185218_acting_user_null.rb
@@ -0,0 +1,10 @@
+class ActingUserNull < ActiveRecord::Migration
+  def up
+    change_column :user_histories, :acting_user_id, :integer, :null => true
+  end
+
+  def down
+    execute "DELETE FROM user_histories WHERE acting_user_id IS NULL"
+    change_column :user_histories, :acting_user_id, :integer, :null => false
+  end
+end
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 22
length: 22
length: 67
length: 42
length: 364
length: 364
hit line +    change_column :posts, :user_id, :integer, null: false
results: 1
hit line +    change_column :topics, :user_id, :integer, null: false
results: 2
hit line +    change_column :user_histories, :acting_user_id, :integer, :null => false
results: 3
cmd cd /Users/jwy/Research/discourse2/; git diff b6545de423781e66a2489e7fb56c9190f204c952 43ce16a6dc667217c6cb1fa61e3af17d2c16bede db/migrate/*
version: b6545de423781e66a2489e7fb56c9190f204c952 vs 43ce16a6dc667217c6cb1fa61e3af17d2c16bede
filename: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
con: diff --git a/db/migrate/20130903154323_allow_null_user_id_on_posts.rb b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
new file mode 100644
index 0000000000..8a9141268d
--- /dev/null
+++ b/db/migrate/20130903154323_allow_null_user_id_on_posts.rb
@@ -0,0 +1,12 @@
+class AllowNullUserIdOnPosts < ActiveRecord::Migration
+  def up
+    change_column :posts, :user_id, :integer, null: true
+    execute "UPDATE posts SET user_id = NULL WHERE nuked_user = true"
+    remove_column :posts, :nuked_user
+  end
+
+  def down
+    add_column    :posts, :nuked_user, :boolean, default: false
+    change_column :posts, :user_id, :integer, null: false
+  end
+end
filename: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
con: diff --git a/db/migrate/20130904181208_allow_null_user_id_on_topics.rb b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
new file mode 100644
index 0000000000..48e9b157d5
--- /dev/null
+++ b/db/migrate/20130904181208_allow_null_user_id_on_topics.rb
@@ -0,0 +1,9 @@
+class AllowNullUserIdOnTopics < ActiveRecord::Migration
+  def up
+    change_column :topics, :user_id, :integer, null: true
+  end
+
+  def down
+    change_column :topics, :user_id, :integer, null: false
+  end
+end
filename: diff --git a/db/migrate/20130912185218_acting_user_null.rb b/db/migrate/20130912185218_acting_user_null.rb
con: diff --git a/db/migrate/20130912185218_acting_user_null.rb b/db/migrate/20130912185218_acting_user_null.rb
new file mode 100644
index 0000000000..fe99e3783c
--- /dev/null
+++ b/db/migrate/20130912185218_acting_user_null.rb
@@ -0,0 +1,10 @@
+class ActingUserNull < ActiveRecord::Migration
+  def up
+    change_column :user_histories, :acting_user_id, :integer, :null => true
+  end
+
+  def down
+    execute "DELETE FROM user_histories WHERE acting_user_id IS NULL"
+    change_column :user_histories, :acting_user_id, :integer, :null => false
+  end
+end
length: 65
length: 65
length: 65
length: 65
length: 48
length: 38
length: 20
length: 20
length: 20
length: 47
length: 67
length: 67
length: 100
length: 100
length: 20
length: 39
length: 17
length: 176
length: 176
length: 176
length: 176
length: 13
length: 19
length: 19
length: 19
length: 19
length: 19
length: 19
length: 19
length: 22
length: 22
length: 28
length: 28
length: 223
length: 223
hit line +    change_column :categories, :position, :integer, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff d078f0f77504061358e6bea1c32063bf290a4a28 e2a5415aca5ea7596b735f73ac8f03c629d43deb db/migrate/*
version: d078f0f77504061358e6bea1c32063bf290a4a28 vs e2a5415aca5ea7596b735f73ac8f03c629d43deb
filename: diff --git a/db/migrate/20131018050738_add_position_to_categories.rb b/db/migrate/20131018050738_add_position_to_categories.rb
con: diff --git a/db/migrate/20131018050738_add_position_to_categories.rb b/db/migrate/20131018050738_add_position_to_categories.rb
new file mode 100644
index 0000000000..65e90a1d1c
--- /dev/null
+++ b/db/migrate/20131018050738_add_position_to_categories.rb
@@ -0,0 +1,11 @@
+class AddPositionToCategories < ActiveRecord::Migration
+  def up
+    add_column :categories, :position, :integer
+    execute "UPDATE categories SET position = id"
+    change_column :categories, :position, :integer, null: false
+  end
+
+  def down
+    remove_column :categories, :position
+  end
+end
length: 28
length: 28
length: 12
length: 41
length: 21
length: 21
length: 21
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
i 5000 length: 11
length: 13
length: 13
length: 13
length: 12
length: 36
length: 36
length: 19
length: 19
length: 19
length: 11
length: 24
length: 13
length: 13
length: 13
length: 15
length: 26
length: 26
length: 11
length: 11
length: 11
length: 17
length: 43
length: 20
length: 34
length: 15
length: 77
length: 77
length: 77
length: 15
length: 16
length: 31
length: 31
length: 31
length: 31
length: 29
length: 13
length: 22
length: 61
length: 61
length: 61
length: 144
length: 144
hit line +    change_column :categories, :position, :integer, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 8835e743a004066e6e5a6694ae718b1813635e3f 6a0072d36eafe6bbb9e444f1ed89b62c1af55f29 db/migrate/*
version: 8835e743a004066e6e5a6694ae718b1813635e3f vs 6a0072d36eafe6bbb9e444f1ed89b62c1af55f29
filename: diff --git a/db/migrate/20131216164557_make_position_nullable_in_categories.rb b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
con: diff --git a/db/migrate/20131216164557_make_position_nullable_in_categories.rb b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
new file mode 100644
index 0000000000..9b7dc619ac
--- /dev/null
+++ b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
@@ -0,0 +1,10 @@
+class MakePositionNullableInCategories < ActiveRecord::Migration
+  def up
+    change_column :categories, :position, :integer, null: true
+  end
+
+  def down
+    execute "update categories set position=0 where position is null"
+    change_column :categories, :position, :integer, null: false
+  end
+end
length: 15
length: 15
length: 174
length: 174
hit line +    change_column :categories, :position, :integer, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 8a386eac4931ae3b3594fd4892a12629f7ee7d55 9c049d9e438c1a3d17006d722c4639c2998e7249 db/migrate/*
version: 8a386eac4931ae3b3594fd4892a12629f7ee7d55 vs 9c049d9e438c1a3d17006d722c4639c2998e7249
filename: diff --git a/db/migrate/20131216164557_make_position_nullable_in_categories.rb b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
con: diff --git a/db/migrate/20131216164557_make_position_nullable_in_categories.rb b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
new file mode 100644
index 0000000000..9b7dc619ac
--- /dev/null
+++ b/db/migrate/20131216164557_make_position_nullable_in_categories.rb
@@ -0,0 +1,10 @@
+class MakePositionNullableInCategories < ActiveRecord::Migration
+  def up
+    change_column :categories, :position, :integer, null: true
+  end
+
+  def down
+    execute "update categories set position=0 where position is null"
+    change_column :categories, :position, :integer, null: false
+  end
+end
length: 11
length: 11
length: 11
length: 11
length: 15
length: 15
length: 15
length: 17
length: 11
length: 31
i 6000 length: 11
length: 11
length: 11
length: 11
length: 11
length: 35
length: 35
length: 37
length: 107
length: 107
length: 11
length: 34
length: 18
length: 11
length: 17
length: 17
length: 11
length: 11
length: 11
length: 17
length: 11
length: 42
length: 42
length: 42
length: 42
length: 42
length: 42
length: 11
length: 22
length: 22
length: 42
length: 64
length: 64
length: 13
length: 13
length: 13
length: 66
length: 66
length: 66
length: 66
length: 66
length: 66
length: 17
length: 17
length: 17
length: 17
length: 17
length: 17
length: 17
length: 11
length: 11
length: 30
length: 30
length: 11
length: 11
length: 11
length: 19
length: 11
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 18
length: 31
length: 16
length: 17
length: 18
length: 16
length: 18
length: 16
length: 16
length: 16
length: 34
length: 34
length: 23
length: 23
length: 23
length: 23
length: 23
length: 85
length: 73
length: 35
length: 35
length: 49
length: 49
length: 49
i 7000 length: 100
length: 100
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 2d9aae80be4d318a07d50efc49c7beddea3ff7d3 d200e68baba3c169eea6d52e3732b4d79c14890e db/migrate/*
version: 2d9aae80be4d318a07d50efc49c7beddea3ff7d3 vs d200e68baba3c169eea6d52e3732b4d79c14890e
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 84
length: 84
length: 165
length: 165
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 5104c7365faef25e7f8b77ed36aa7e63bbf32fae bbde2aaa97938305038e3ba0af9064b86badf7e9 db/migrate/*
version: 5104c7365faef25e7f8b77ed36aa7e63bbf32fae vs bbde2aaa97938305038e3ba0af9064b86badf7e9
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 56
length: 56
length: 100
length: 100
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 6e667476a08d6596a065e531594db3624e1f4bae 0bb9b607cc1a186b8507b6b560e190b702197f37 db/migrate/*
version: 6e667476a08d6596a065e531594db3624e1f4bae vs 0bb9b607cc1a186b8507b6b560e190b702197f37
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 56
length: 156
length: 156
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 1cebbbc5e381a14c28e00e8946ce9a10cdd01070 3cf0adaed0d8601adf47094008788c2a1f93d12c db/migrate/*
version: 1cebbbc5e381a14c28e00e8946ce9a10cdd01070 vs 3cf0adaed0d8601adf47094008788c2a1f93d12c
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 24
length: 24
length: 24
length: 80
length: 80
length: 24
length: 24
length: 23
length: 47
length: 47
length: 11
length: 11
length: 11
length: 11
length: 18
length: 12
length: 13
length: 37
length: 37
length: 37
length: 50
length: 50
length: 50
length: 50
length: 50
length: 50
length: 50
length: 50
length: 15
length: 11
length: 11
length: 11
length: 26
length: 26
length: 18
length: 11
length: 11
length: 11
length: 39
length: 11
length: 11
length: 11
length: 11
length: 11
length: 34
length: 27
length: 72
length: 61
length: 482
length: 482
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 891a1c4279fbe1aef023b6289c07d1507721a8d2 2e7b69f849a0b1b942dd21f0de1e867790662789 db/migrate/*
version: 891a1c4279fbe1aef023b6289c07d1507721a8d2 vs 2e7b69f849a0b1b942dd21f0de1e867790662789
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 482
length: 482
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 43ed6979be6570c6359b90017432614554eff1bd ce381860dcbfe79e12a1682d62e941d28dbba40b db/migrate/*
version: 43ed6979be6570c6359b90017432614554eff1bd vs ce381860dcbfe79e12a1682d62e941d28dbba40b
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 482
length: 482
hit line +    change_column :user_stats, :new_since, :datetime, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff deb99e956e5eed6fad67aa6e537be5034db27d4b c680d7457132af79d330d4b6754fb913ab9665ce db/migrate/*
version: deb99e956e5eed6fad67aa6e537be5034db27d4b vs c680d7457132af79d330d4b6754fb913ab9665ce
filename: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
con: diff --git a/db/migrate/20140303185354_add_new_since_to_user_stats.rb b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
new file mode 100644
index 0000000000..f0e1a071cd
--- /dev/null
+++ b/db/migrate/20140303185354_add_new_since_to_user_stats.rb
@@ -0,0 +1,10 @@
+class AddNewSinceToUserStats < ActiveRecord::Migration
+  def change
+    add_column :user_stats, :new_since, :datetime
+    execute "UPDATE user_stats AS us
+               SET new_since = u.created_at
+             FROM users AS u
+              WHERE u.id = us.user_id"
+    change_column :user_stats, :new_since, :datetime, null: false
+  end
+end
length: 11
length: 11
length: 11
i 8000 length: 48
length: 48
length: 48
length: 48
length: 48
length: 15
length: 146
length: 146
length: 13
length: 11
length: 11
length: 11
length: 30
length: 58
length: 58
length: 58
length: 58
length: 58
length: 79
length: 79
length: 79
length: 23
length: 23
length: 45
length: 22
length: 49
length: 49
length: 17
length: 55
length: 55
length: 55
length: 55
length: 55
length: 55
length: 12
length: 11
length: 29
length: 40
length: 153
length: 153
length: 18
length: 20
length: 11
length: 11
length: 11
length: 23
length: 50
length: 11
length: 30
length: 30
length: 30
length: 30
length: 30
length: 30
length: 30
length: 30
length: 30
length: 23
length: 23
length: 23
length: 23
length: 30
length: 53
length: 53
length: 53
length: 53
length: 53
length: 31
length: 31
length: 31
length: 11
length: 11
length: 11
length: 15
length: 16
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 33
length: 33
length: 11
length: 11
length: 11
i 9000 length: 17
length: 28
length: 28
length: 17
length: 23
length: 23
length: 23
length: 23
length: 23
length: 68
length: 68
length: 12
length: 13
length: 17
length: 18
length: 26
length: 15
length: 15
length: 15
length: 15
length: 15
length: 29
length: 11
length: 36
length: 11
length: 26
length: 11
length: 15
length: 15
length: 32
length: 11
length: 60
length: 129
length: 129
length: 129
length: 129
length: 60
length: 60
length: 17
length: 19
length: 32
length: 51
length: 51
length: 11
length: 23
length: 18
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 25
length: 11
length: 11
length: 12
length: 12
length: 11
length: 12
length: 23
length: 23
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 130
length: 141
length: 141
length: 147
length: 147
length: 17
length: 17
length: 17
length: 11
length: 11
length: 11
length: 33
length: 22
length: 11
length: 11
length: 11
length: 11
length: 11
length: 27
length: 84
length: 26
length: 62
length: 12
length: 211
length: 211
hit line +    change_column :incoming_links, :post_id, :integer, null: false
results: 1
hit line +    change_column :incoming_referers, :incoming_domain_id, :integer, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 4cd8abc905df95975d896da32be9d42aa6cd928f 06c681b0de820c9eb26b4c3ab86c21cb6e479352 db/migrate/*
version: 4cd8abc905df95975d896da32be9d42aa6cd928f vs 06c681b0de820c9eb26b4c3ab86c21cb6e479352
filename: diff --git a/db/migrate/20140801052028_fix_incoming_links.rb b/db/migrate/20140801052028_fix_incoming_links.rb
con: diff --git a/db/migrate/20140801052028_fix_incoming_links.rb b/db/migrate/20140801052028_fix_incoming_links.rb
new file mode 100644
index 0000000000..c00ac021a2
--- /dev/null
+++ b/db/migrate/20140801052028_fix_incoming_links.rb
@@ -0,0 +1,21 @@
+class FixIncomingLinks < ActiveRecord::Migration
+  def up
+    execute "DROP INDEX incoming_index"
+    add_column :incoming_links, :post_id, :integer
+    remove_column :incoming_links, :updated_at
+    remove_column :incoming_links, :url
+
+    execute "UPDATE incoming_links l SET post_id = (
+      SELECT p.id FROM posts p WHERE p.topic_id = l.topic_id AND p.post_number = l.post_number
+    )"
+
+    execute "DELETE FROM incoming_links WHERE post_id IS NULL"
+    change_column :incoming_links, :post_id, :integer, null: false
+
+    add_index :incoming_links, :post_id
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20140804010803_incoming_link_normalization.rb b/db/migrate/20140804010803_incoming_link_normalization.rb
con: diff --git a/db/migrate/20140804010803_incoming_link_normalization.rb b/db/migrate/20140804010803_incoming_link_normalization.rb
new file mode 100644
index 0000000000..2c3743541a
--- /dev/null
+++ b/db/migrate/20140804010803_incoming_link_normalization.rb
@@ -0,0 +1,78 @@
+class IncomingLinkNormalization < ActiveRecord::Migration
+  def up
+    remove_column :incoming_links, :post_number
+    remove_column :incoming_links, :domain
+    add_column :incoming_links, :incoming_referer_id, :integer
+
+    create_table :incoming_referers do |t|
+      t.string :url, limit: 1000, null: false
+      t.string :domain, limit: 100, null: false
+      t.string :path, limit: 1000, null: false
+      t.integer :port, null: false
+      t.boolean :https, null: false
+      t.integer :incoming_domain_id
+    end
+
+    # start the shuffle
+    #
+    execute "INSERT INTO incoming_referers(url, https, domain, port, path)
+             SELECT referer,
+                    CASE WHEN a[1] = 's' THEN true ELSE false END,
+                    a[2] as domain,
+                    CASE WHEN a[1] = 's' THEN
+                      COALESCE(a[4]::integer, 443)::integer
+                    ELSE
+                      COALESCE(a[4]::integer, 80)::integer
+                    END,
+                    COALESCE(a[5], '') path
+             FROM
+            (
+              SELECT referer, regexp_matches(referer, 'http(s)?://([^/:]+)(:(\d+))?(.*)') a
+              FROM
+              (
+               SELECT DISTINCT referer
+               FROM incoming_links WHERE referer ~ '^https?://.+'
+              ) Z
+            ) X
+          WHERE a[2] IS NOT NULL"
+
+
+    execute "UPDATE incoming_links l
+    SET incoming_referer_id = r.id
+    FROM incoming_referers r
+    WHERE r.url = l.referer"
+
+    create_table :incoming_domains do |t|
+      t.string :name, limit: 100, null: false
+      t.boolean :https, null: false, default: false
+      t.integer :port, null: false
+    end
+
+    # shuffle part 2
+    #
+    execute "INSERT INTO incoming_domains(name, port, https)
+    SELECT DISTINCT domain, port, https
+    FROM incoming_referers"
+
+    execute "UPDATE incoming_referers l
+    SET incoming_domain_id = d.id
+    FROM incoming_domains d
+    WHERE d.name = l.domain AND d.https = l.https AND d.port = l.port"
+
+
+    remove_column :incoming_referers, :domain
+    remove_column :incoming_referers, :port
+    remove_column :incoming_referers, :https
+
+    change_column :incoming_referers, :incoming_domain_id, :integer, null: false
+
+    add_index :incoming_referers, [:path, :incoming_domain_id], unique: true
+    add_index :incoming_domains, [:name, :https, :port], unique: true
+
+    remove_column :incoming_links, :referer
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
length: 15
length: 11
i 10000 length: 23
length: 40
length: 12
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 32
length: 32
length: 32
length: 17
length: 11
length: 19
length: 19
length: 19
length: 12
length: 12
length: 30
length: 30
length: 12
length: 102
length: 102
length: 12
length: 12
length: 15
length: 15
length: 48
length: 63
length: 63
length: 20
length: 20
length: 36
length: 36
length: 36
length: 36
length: 36
length: 15
length: 51
length: 51
length: 51
length: 51
length: 51
length: 51
length: 51
length: 51
length: 51
length: 51
length: 19
length: 19
length: 19
length: 19
length: 19
length: 19
length: 19
length: 53
length: 11
length: 64
length: 64
length: 22
length: 86
length: 86
length: 13
length: 13
length: 39
length: 18
length: 18
length: 18
length: 14
length: 12
length: 12
length: 12
length: 12
length: 15
length: 10
length: 10
length: 10
length: 15
length: 15
length: 11
i 11000 length: 11
length: 11
length: 11
length: 11
length: 26
length: 26
length: 13
length: 13
length: 13
length: 15
length: 39
length: 39
length: 25
length: 11
length: 22
length: 13
length: 11
length: 11
length: 11
length: 13
length: 13
length: 13
length: 25
length: 25
length: 25
length: 11
length: 11
length: 11
length: 11
length: 23
length: 23
length: 23
length: 23
length: 23
length: 23
length: 23
length: 23
length: 23
length: 23
length: 24
length: 47
length: 47
length: 47
length: 11
length: 12
length: 46
length: 46
length: 24
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 22
length: 33
length: 33
length: 33
length: 33
length: 125
length: 125
length: 102
length: 102
length: 125
length: 125
length: 21
length: 21
length: 21
length: 146
length: 146
length: 11
length: 12
length: 12
length: 12
length: 2747
length: 2747
hit line +    change_column :incoming_links, :post_id, :integer, null: false
results: 1
hit line +    change_column :incoming_referers, :incoming_domain_id, :integer, null: false
results: 2
hit line +      change_column table.to_sym, column.to_sym, :datetime, null: false
results: 3
hit line +    change_column :permalinks, :url, :string, limit: 1000, null: false
results: 4
hit line +    change_column :user_fields, :description, :string, null: false
results: 5
cmd cd /Users/jwy/Research/discourse2/; git diff d07c6c8cbb697a96cc4bd9a9e31f7bbc24eb4103 4fc3834dd6cd4fa4f9297e83fa2c85680d34e498 db/migrate/*
version: d07c6c8cbb697a96cc4bd9a9e31f7bbc24eb4103 vs 4fc3834dd6cd4fa4f9297e83fa2c85680d34e498
filename: diff --git a/db/migrate/20140801052028_fix_incoming_links.rb b/db/migrate/20140801052028_fix_incoming_links.rb
con: diff --git a/db/migrate/20140801052028_fix_incoming_links.rb b/db/migrate/20140801052028_fix_incoming_links.rb
new file mode 100644
index 0000000000..c00ac021a2
--- /dev/null
+++ b/db/migrate/20140801052028_fix_incoming_links.rb
@@ -0,0 +1,21 @@
+class FixIncomingLinks < ActiveRecord::Migration
+  def up
+    execute "DROP INDEX incoming_index"
+    add_column :incoming_links, :post_id, :integer
+    remove_column :incoming_links, :updated_at
+    remove_column :incoming_links, :url
+
+    execute "UPDATE incoming_links l SET post_id = (
+      SELECT p.id FROM posts p WHERE p.topic_id = l.topic_id AND p.post_number = l.post_number
+    )"
+
+    execute "DELETE FROM incoming_links WHERE post_id IS NULL"
+    change_column :incoming_links, :post_id, :integer, null: false
+
+    add_index :incoming_links, :post_id
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20140804010803_incoming_link_normalization.rb b/db/migrate/20140804010803_incoming_link_normalization.rb
con: diff --git a/db/migrate/20140804010803_incoming_link_normalization.rb b/db/migrate/20140804010803_incoming_link_normalization.rb
new file mode 100644
index 0000000000..2c3743541a
--- /dev/null
+++ b/db/migrate/20140804010803_incoming_link_normalization.rb
@@ -0,0 +1,78 @@
+class IncomingLinkNormalization < ActiveRecord::Migration
+  def up
+    remove_column :incoming_links, :post_number
+    remove_column :incoming_links, :domain
+    add_column :incoming_links, :incoming_referer_id, :integer
+
+    create_table :incoming_referers do |t|
+      t.string :url, limit: 1000, null: false
+      t.string :domain, limit: 100, null: false
+      t.string :path, limit: 1000, null: false
+      t.integer :port, null: false
+      t.boolean :https, null: false
+      t.integer :incoming_domain_id
+    end
+
+    # start the shuffle
+    #
+    execute "INSERT INTO incoming_referers(url, https, domain, port, path)
+             SELECT referer,
+                    CASE WHEN a[1] = 's' THEN true ELSE false END,
+                    a[2] as domain,
+                    CASE WHEN a[1] = 's' THEN
+                      COALESCE(a[4]::integer, 443)::integer
+                    ELSE
+                      COALESCE(a[4]::integer, 80)::integer
+                    END,
+                    COALESCE(a[5], '') path
+             FROM
+            (
+              SELECT referer, regexp_matches(referer, 'http(s)?://([^/:]+)(:(\d+))?(.*)') a
+              FROM
+              (
+               SELECT DISTINCT referer
+               FROM incoming_links WHERE referer ~ '^https?://.+'
+              ) Z
+            ) X
+          WHERE a[2] IS NOT NULL"
+
+
+    execute "UPDATE incoming_links l
+    SET incoming_referer_id = r.id
+    FROM incoming_referers r
+    WHERE r.url = l.referer"
+
+    create_table :incoming_domains do |t|
+      t.string :name, limit: 100, null: false
+      t.boolean :https, null: false, default: false
+      t.integer :port, null: false
+    end
+
+    # shuffle part 2
+    #
+    execute "INSERT INTO incoming_domains(name, port, https)
+    SELECT DISTINCT domain, port, https
+    FROM incoming_referers"
+
+    execute "UPDATE incoming_referers l
+    SET incoming_domain_id = d.id
+    FROM incoming_domains d
+    WHERE d.name = l.domain AND d.https = l.https AND d.port = l.port"
+
+
+    remove_column :incoming_referers, :domain
+    remove_column :incoming_referers, :port
+    remove_column :incoming_referers, :https
+
+    change_column :incoming_referers, :incoming_domain_id, :integer, null: false
+
+    add_index :incoming_referers, [:path, :incoming_domain_id], unique: true
+    add_index :incoming_domains, [:name, :https, :port], unique: true
+
+    remove_column :incoming_links, :referer
+  end
+
+  def down
+    raise ActiveRecord::IrreversibleMigration
+  end
+end
filename: diff --git a/db/migrate/20140827044811_remove_nullable_dates.rb b/db/migrate/20140827044811_remove_nullable_dates.rb
con: diff --git a/db/migrate/20140827044811_remove_nullable_dates.rb b/db/migrate/20140827044811_remove_nullable_dates.rb
new file mode 100644
index 0000000000..3f8f2211be
--- /dev/null
+++ b/db/migrate/20140827044811_remove_nullable_dates.rb
@@ -0,0 +1,42 @@
+class RemoveNullableDates < ActiveRecord::Migration
+  def up
+
+    # must drop so we can muck with the column
+    execute "DROP VIEW badge_posts"
+
+    # Rails 3 used to have nullable created_at and updated_at dates
+    #  this is no longer the case in Rails 4, some old installs have
+    #  this relic
+    #  Fix it
+    sql = "select table_name, column_name from information_schema.columns
+           WHERE  column_name IN ('created_at','updated_at') AND
+                  table_schema = 'public' AND
+                  is_nullable = 'YES' AND
+                  is_updatable = 'YES' AND
+                  data_type = 'timestamp without time zone'"
+
+    execute(sql).each do |row|
+      table = row["table_name"]
+      column = row["column_name"]
+
+      execute "UPDATE \"#{table}\" SET #{column} = CURRENT_TIMESTAMP WHERE #{column} IS NULL"
+      change_column table.to_sym, column.to_sym, :datetime, null: false
+    end
+
+    execute "CREATE VIEW badge_posts AS
+    SELECT p.*
+    FROM posts p
+    JOIN topics t ON t.id = p.topic_id
+    JOIN categories c ON c.id = t.category_id
+    WHERE c.allow_badges AND
+          p.deleted_at IS NULL AND
+          t.deleted_at IS NULL AND
+          NOT c.read_restricted AND
+          t.visible"
+
+  end
+
+  def down
+    # no need to revert
+  end
+end
filename: diff --git a/db/migrate/20140828200231_make_url_col_bigger_in_permalinks.rb b/db/migrate/20140828200231_make_url_col_bigger_in_permalinks.rb
con: diff --git a/db/migrate/20140828200231_make_url_col_bigger_in_permalinks.rb b/db/migrate/20140828200231_make_url_col_bigger_in_permalinks.rb
new file mode 100644
index 0000000000..f2767d1a2a
--- /dev/null
+++ b/db/migrate/20140828200231_make_url_col_bigger_in_permalinks.rb
@@ -0,0 +1,10 @@
+class MakeUrlColBiggerInPermalinks < ActiveRecord::Migration
+  def up
+    remove_index :permalinks, :url
+    change_column :permalinks, :url, :string, limit: 1000, null: false
+    add_index :permalinks, :url, unique: true
+  end
+
+  def down
+  end
+end
filename: diff --git a/db/migrate/20141002181613_add_description_to_user_fields.rb b/db/migrate/20141002181613_add_description_to_user_fields.rb
con: diff --git a/db/migrate/20141002181613_add_description_to_user_fields.rb b/db/migrate/20141002181613_add_description_to_user_fields.rb
new file mode 100644
index 0000000000..5bebb80bde
--- /dev/null
+++ b/db/migrate/20141002181613_add_description_to_user_fields.rb
@@ -0,0 +1,7 @@
+class AddDescriptionToUserFields < ActiveRecord::Migration
+  def change
+    add_column :user_fields, :description, :string, null: true
+    execute "UPDATE user_fields SET description=name"
+    change_column :user_fields, :description, :string, null: false
+  end
+end
length: 17
length: 17
length: 17
length: 13
length: 13
length: 43
length: 43
length: 26
length: 26
i 12000 length: 25
length: 25
length: 25
length: 29
length: 29
length: 29
length: 29
length: 29
length: 54
length: 54
length: 26
length: 11
length: 11
length: 15
length: 15
length: 15
length: 11
length: 11
length: 11
length: 11
length: 11
length: 16
length: 12
length: 35
length: 34
length: 13
length: 33
length: 11
length: 269
length: 269
length: 118
length: 118
length: 41
length: 39
length: 17
length: 17
length: 11
length: 11
length: 11
length: 17
length: 11
length: 12
length: 12
length: 12
length: 12
length: 12
length: 11
length: 17
length: 16
length: 16
length: 16
length: 11
length: 14
length: 14
length: 14
i 13000 length: 52
length: 52
length: 52
length: 52
length: 52
length: 12
length: 20
length: 11
length: 12
length: 23
cnt : 1000 length: 23
length: 16
length: 24
length: 40
length: 40
length: 22
length: 22
length: 22
length: 11
length: 11
length: 18
length: 12
length: 11
length: 22
length: 50
length: 50
length: 50
length: 16
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 44
length: 44
length: 44
length: 44
length: 44
i 14000 length: 18
length: 51
length: 69
length: 69
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 11
length: 33
length: 33
length: 19
length: 76
length: 76
length: 76
length: 11
length: 11
length: 11
length: 11
length: 23
length: 34
length: 34
i 15000 length: 11
length: 11
length: 15
length: 82
length: 82
length: 16
length: 16
length: 16
length: 16
length: 16
length: 16
length: 16
length: 16
length: 16
length: 14
length: 240
length: 240
length: 56
length: 56
length: 11
length: 11
length: 11
length: 11
length: 42
length: 15
length: 20
length: 35
length: 35
length: 67
length: 35
length: 37
length: 11
length: 22
length: 12
length: 12
length: 12
length: 12
length: 22
length: 42
length: 12
length: 39
length: 21
length: 43
length: 43
length: 43
length: 43
length: 43
length: 43
length: 43
length: 43
length: 43
length: 43
length: 11
i 16000 i 17000 i 18000 i 19000 i 20000 i 21000 i 22000 i 23000 length: 248
hit line +    change_column :users, :email, :string, limit: 256, null: false
results: 1
hit line +    change_column :users, :username_lower, :string, limit: 20, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff ff4e295c4fa72c05829959610f20faa02e71e5ff 5012d46cbd3bcf79b7351f7d2d41003496a796c5 db/migrate/*
version: ff4e295c4fa72c05829959610f20faa02e71e5ff vs 5012d46cbd3bcf79b7351f7d2d41003496a796c5
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index bd1e05bea2..4bd5e9b733 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit:256, null: false
+    change_column :users, :email, :string, limit: 256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key,:string, limit: 32
+    add_column :users, :activation_key, :string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
filename: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
con: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
index 764fae375d..38602aa2aa 100644
--- a/db/migrate/20120720013733_add_username_lower_to_users.rb
+++ b/db/migrate/20120720013733_add_username_lower_to_users.rb
@@ -3,7 +3,7 @@ class AddUsernameLowerToUsers < ActiveRecord::Migration
     add_column :users, :username_lower, :string, limit: 20
     execute "update users set username_lower = lower(username)"
     add_index :users, [:username_lower], unique: true
-    change_column :users, :username_lower, :string, limit: 20, null:false
+    change_column :users, :username_lower, :string, limit: 20, null: false
   end
   def down
     remove_column :users, :username_lower
length: 248
hit line +    change_column :users, :email, :string, limit:256, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff c7f76aa554550564669f304d9601f8678ce1e912 f8edf2636cb18324a7f9972ff1a821e598f9b6fb db/migrate/*
version: c7f76aa554550564669f304d9601f8678ce1e912 vs f8edf2636cb18324a7f9972ff1a821e598f9b6fb
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index 4bd5e9b733..bd1e05bea2 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit: 256, null: false
+    change_column :users, :email, :string, limit:256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key, :string, limit: 32
+    add_column :users, :activation_key,:string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
length: 248
hit line +    change_column :users, :email, :string, limit: 256, null: false
results: 1
hit line +    change_column :users, :username_lower, :string, limit: 20, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff f8edf2636cb18324a7f9972ff1a821e598f9b6fb 2e2b5e28aa6711a549715a3892f062981546c270 db/migrate/*
version: f8edf2636cb18324a7f9972ff1a821e598f9b6fb vs 2e2b5e28aa6711a549715a3892f062981546c270
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index bd1e05bea2..4bd5e9b733 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit:256, null: false
+    change_column :users, :email, :string, limit: 256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key,:string, limit: 32
+    add_column :users, :activation_key, :string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
filename: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
con: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
index 764fae375d..38602aa2aa 100644
--- a/db/migrate/20120720013733_add_username_lower_to_users.rb
+++ b/db/migrate/20120720013733_add_username_lower_to_users.rb
@@ -3,7 +3,7 @@ class AddUsernameLowerToUsers < ActiveRecord::Migration
     add_column :users, :username_lower, :string, limit: 20
     execute "update users set username_lower = lower(username)"
     add_index :users, [:username_lower], unique: true
-    change_column :users, :username_lower, :string, limit: 20, null:false
+    change_column :users, :username_lower, :string, limit: 20, null: false
   end
   def down
     remove_column :users, :username_lower
i 24000 length: 564
length: 564
length: 564
length: 564
length: 564
length: 789
hit line +    change_column :users, :email, :string, limit:256, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff 38eef177d4547cdd182569958084389fb49f6f75 8124f26a6e2cba7b33e491336fb7971b79bba950 db/migrate/*
version: 38eef177d4547cdd182569958084389fb49f6f75 vs 8124f26a6e2cba7b33e491336fb7971b79bba950
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index 4bd5e9b733..bd1e05bea2 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit: 256, null: false
+    change_column :users, :email, :string, limit:256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key, :string, limit: 32
+    add_column :users, :activation_key,:string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
length: 789
hit line +    change_column :users, :email, :string, limit: 256, null: false
results: 1
hit line +    change_column :users, :username_lower, :string, limit: 20, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff 8124f26a6e2cba7b33e491336fb7971b79bba950 16b67745d8c5f75bd705b6d86310704e47df27a2 db/migrate/*
version: 8124f26a6e2cba7b33e491336fb7971b79bba950 vs 16b67745d8c5f75bd705b6d86310704e47df27a2
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index bd1e05bea2..4bd5e9b733 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit:256, null: false
+    change_column :users, :email, :string, limit: 256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key,:string, limit: 32
+    add_column :users, :activation_key, :string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
filename: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
con: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
index 764fae375d..38602aa2aa 100644
--- a/db/migrate/20120720013733_add_username_lower_to_users.rb
+++ b/db/migrate/20120720013733_add_username_lower_to_users.rb
@@ -3,7 +3,7 @@ class AddUsernameLowerToUsers < ActiveRecord::Migration
     add_column :users, :username_lower, :string, limit: 20
     execute "update users set username_lower = lower(username)"
     add_index :users, [:username_lower], unique: true
-    change_column :users, :username_lower, :string, limit: 20, null:false
+    change_column :users, :username_lower, :string, limit: 20, null: false
   end
   def down
     remove_column :users, :username_lower
length: 789
hit line +    change_column :users, :email, :string, limit:256, null: false
results: 1
cmd cd /Users/jwy/Research/discourse2/; git diff afe6f46b03bc4c955a85408acce96a1e2f35df5b bb098af38ee0900b838d5527fe29db6f8a42b4c3 db/migrate/*
version: afe6f46b03bc4c955a85408acce96a1e2f35df5b vs bb098af38ee0900b838d5527fe29db6f8a42b4c3
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index 4bd5e9b733..bd1e05bea2 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit: 256, null: false
+    change_column :users, :email, :string, limit:256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key, :string, limit: 32
+    add_column :users, :activation_key,:string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
length: 789
hit line +    change_column :users, :email, :string, limit: 256, null: false
results: 1
hit line +    change_column :users, :username_lower, :string, limit: 20, null: false
results: 2
cmd cd /Users/jwy/Research/discourse2/; git diff bb098af38ee0900b838d5527fe29db6f8a42b4c3 be1cce503c3576426ac9759d88fdcab4c0b87be2 db/migrate/*
version: bb098af38ee0900b838d5527fe29db6f8a42b4c3 vs be1cce503c3576426ac9759d88fdcab4c0b87be2
filename: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
con: diff --git a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
index bd1e05bea2..4bd5e9b733 100644
--- a/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
+++ b/db/migrate/20120719004636_add_email_hashed_password_name_salt_to_users.rb
@@ -4,7 +4,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
 
     execute "update users set email= md5(random()::text) || 'domain.com'"
 
-    change_column :users, :email, :string, limit:256, null: false
+    change_column :users, :email, :string, limit: 256, null: false
     add_index :users, [:email], unique: true
 
     rename_column :users, :display_username, :name
@@ -12,7 +12,7 @@ class AddEmailHashedPasswordNameSaltToUsers < ActiveRecord::Migration
     add_column :users, :password_hash, :string, limit: 64
     add_column :users, :salt, :string, limit: 32
     add_column :users, :active, :boolean
-    add_column :users, :activation_key,:string, limit: 32
+    add_column :users, :activation_key, :string, limit: 32
 
     add_column :user_open_ids, :active, :boolean, null: false
 
filename: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
con: diff --git a/db/migrate/20120720013733_add_username_lower_to_users.rb b/db/migrate/20120720013733_add_username_lower_to_users.rb
index 764fae375d..38602aa2aa 100644
--- a/db/migrate/20120720013733_add_username_lower_to_users.rb
+++ b/db/migrate/20120720013733_add_username_lower_to_users.rb
@@ -3,7 +3,7 @@ class AddUsernameLowerToUsers < ActiveRecord::Migration
     add_column :users, :username_lower, :string, limit: 20
     execute "update users set username_lower = lower(username)"
     add_index :users, [:username_lower], unique: true
-    change_column :users, :username_lower, :string, limit: 20, null:false
+    change_column :users, :username_lower, :string, limit: 20, null: false
   end
   def down
     remove_column :users, :username_lower
length: 2072
length: 2072
length: 2072
length: 2072
length: 2072
i 25000 i 26000 i 27000 i 28000 length: 17
length: 26
length: 16
i 29000 length: 13
length: 13
length: 13
length: 13
length: 13
i 30000 i 31000 length: 29
