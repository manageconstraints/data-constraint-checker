12908
i 1000 hit line +    change_column :changesets, :revision, :string, :null => false
results: 1
hit line +    change_column :changesets, :revision, :integer, :null => false
results: 1
version: 6fcc512cb77a0851ab8c3c693fd178b564a600dd vs 3a9b0988c7515371531e47f9eef9f8e60ce352aa
filename: diff --git a/db/migrate/091_change_changesets_revision_to_string.rb b/db/migrate/091_change_changesets_revision_to_string.rb
con: diff --git a/db/migrate/091_change_changesets_revision_to_string.rb b/db/migrate/091_change_changesets_revision_to_string.rb
new file mode 100644
index 000000000..e621a3909
--- /dev/null
+++ b/db/migrate/091_change_changesets_revision_to_string.rb
@@ -0,0 +1,9 @@
+class ChangeChangesetsRevisionToString < ActiveRecord::Migration
+  def self.up
+    change_column :changesets, :revision, :string, :null => false
+  end
+
+  def self.down
+    change_column :changesets, :revision, :integer, :null => false
+  end
+end
i 2000 i 3000 i 4000 i 5000 i 6000 i 7000 i 8000 i 9000 i 10000 i 11000 i 12000 