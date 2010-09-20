From: Jie Liu <jeff.liu@oracle.com>
Date: Mon, 20 Sep 2010 15:12:02 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] shared-du: using fiemap to figure up the
	shared extents per file and the footprint in all v4
In-Reply-To: <>
References: <>
Message-ID: <1284966722-24945-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

If issue du(1) with either '--shared-size' or '-E' option, show the shared extents in parens per
file as well as the footprint in the end.

* src/du.c: Add this feature.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 coreutils-6.9/src/du.c |  479 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 473 insertions(+), 6 deletions(-)

diff --git a/coreutils-6.9/src/du.c b/coreutils-6.9/src/du.c
index 206d318..41fda57 100644
--- a/coreutils-6.9/src/du.c
+++ b/coreutils-6.9/src/du.c
@@ -45,6 +45,13 @@
 #include "xfts.h"
 #include "xstrtol.h"
 
+#include "fiemap.h"
+#include "rbtree.h"
+
+#if HAVE_SYS_IOCTL_H
+# include <sys/ioctl.h>
+#endif
+
 extern bool fts_debug;
 
 /* The official name of this program (e.g., no `g' prefix).  */
@@ -64,6 +71,10 @@ extern bool fts_debug;
 /* Initial size of the hash table.  */
 #define INITIAL_TABLE_SIZE 103
 
+#if defined(_IOWR) && !defined(FS_IOC_FIEMAP)
+# define FS_IOC_FIEMAP _IOWR('f', 11, struct fiemap)
+#endif
+
 /* Hash structure for inode and device numbers.  The separate entry
    structure makes it easier to rehash "in place".  */
 
@@ -171,6 +182,31 @@ static enum time_type time_type = time_mtime;
 /* User specified date / time style */
 static char const *time_style = NULL;
 
+/* If true, display the size of the shared extents per file and end
+   up with the overall footprint.  */
+static bool print_shared_size = false;
+
+/* The size of the shared extents per file.  */
+static uint64_t file_shared_extents = 0;
+
+/* The root of our rbtree for tracking extent_info as below.  */
+static struct rb_root fe_root;
+
+/* A structure for the extents information.  */
+struct extent_info {
+  /* rbtree node */
+  struct rb_node ei_node;
+
+  /* physical offset in bytes */
+  uint64_t ei_physical;
+
+  /* length in bytes for this extent */
+  uint64_t ei_length;
+
+  /* extent shared count */
+  size_t ei_shared_count;
+};
+
 /* Format used to display date / time. Controlled by --time-style */
 static char const *time_format = NULL;
 
@@ -215,6 +251,7 @@ static struct option const long_options[] =
   {"block-size", required_argument, NULL, 'B'},
   {"bytes", no_argument, NULL, 'b'},
   {"count-links", no_argument, NULL, 'l'},
+  {"shared-size", no_argument, NULL, 'E'},
   {"dereference", no_argument, NULL, 'L'},
   {"dereference-args", no_argument, NULL, 'D'},
   {"exclude", required_argument, NULL, EXCLUDE_OPTION},
@@ -299,6 +336,7 @@ Mandatory arguments to long options are mandatory for short options too.\n\
   -b, --bytes           equivalent to `--apparent-size --block-size=1'\n\
   -c, --total           produce a grand total\n\
   -D, --dereference-args  dereference FILEs that are symbolic links\n\
+  -E, --shared-size     show the size of the shared extents per file\n\
 "), stdout);
       fputs (_("\
       --files0-from=F   summarize disk usage of the NUL-terminated file\n\
@@ -443,6 +481,22 @@ print_only_size (uintmax_t n_bytes)
 			 1, output_block_size), stdout);
 }
 
+/* Print footprint follow by STRING. */
+
+static void
+print_footprint (const struct duinfo *pdui, uintmax_t footprint, const char *string)
+{
+  print_only_size (footprint);
+  if (opt_time)
+    {
+      putchar ('\t');
+      show_date (time_format, pdui->tmax);
+    }
+
+  printf ("\t%s%c", string, opt_nul_terminate_output ? '\0' : '\n');
+  fflush (stdout);
+}
+
 /* Print size (and optionally time) indicated by *PDUI, followed by STRING.  */
 
 static void
@@ -454,10 +508,400 @@ print_size (const struct duinfo *pdui, const char *string)
       putchar ('\t');
       show_date (time_format, pdui->tmax);
     }
+
+  /* FIXME: make better formatting output?  */
+  if ((print_shared_size) && (file_shared_extents > 0))
+    {
+      putchar ('\t');
+      putchar ('(');
+
+      /* If display file size in bytes (i.e, output_block_size == 1), we
+         should honor pdui->size if the file shared extent size is larger
+         than it.  */
+      if ((output_block_size == 1) && (file_shared_extents > pdui->size))
+        file_shared_extents = pdui->size;
+
+      print_only_size (file_shared_extents);
+      putchar (')');
+
+      file_shared_extents = 0;
+    }
   printf ("\t%s%c", string, opt_nul_terminate_output ? '\0' : '\n');
   fflush (stdout);
 }
 
+/* Free all allocated extent_info node from the rbtree.  */
+
+static void
+free_extent_info (void)
+{
+  struct rb_node *node;
+  struct extent_info *ei;
+
+  while ((node = rb_first (&fe_root)))
+    {
+      ei = rb_entry (node, struct extent_info, ei_node);
+      rb_erase (&ei->ei_node, &fe_root);
+      free (ei);
+    }
+}
+
+/* Go through the entire tree to sum up the shared extents
+   for whose ei_shared_count > 0.  */
+
+static uintmax_t
+figure_up_shared_extent (void)
+{
+  struct rb_node *node;
+  struct extent_info *ei;
+  static uintmax_t total_shared_extent = 0;
+
+  for (node = rb_first (&fe_root); node; node = rb_next (node))
+  {
+    ei = rb_entry (node, struct extent_info, ei_node);
+    if (ei->ei_shared_count > 0)
+      total_shared_extent += ei->ei_length * ei->ei_shared_count;
+  }
+
+  return total_shared_extent;
+}
+
+/* Check to see if two extent_info structs are adjacent and they have
+   same shared count which is greater than zero.  */
+
+static bool
+mergable_extent_info (struct extent_info *prev_ei, struct extent_info *ei)
+{
+  return (prev_ei->ei_shared_count == ei->ei_shared_count
+          && prev_ei->ei_physical + prev_ei->ei_length == ei->ei_physical)
+          ? true : false;
+}
+
+/* Insert the new extent_info based on the parent.
+   We should make sure that all splitted extent_info tracks
+   on the rbtree does not has any overlap, so we should abort
+   du process if the extents physical offset is equivalent.
+   After inserting, try to merge to the left or right node.  */
+
+static void
+insert_extent_info (struct rb_node *parent,
+                    uint64_t fe_physical,
+                    uint64_t fe_length,
+                    size_t extent_shared_count)
+{
+  struct rb_node **p = parent ? &parent : &((&fe_root)->rb_node);
+  struct rb_node *pp = NULL;
+  struct rb_node *node;
+  struct rb_node *new_node;
+  struct extent_info *ei;
+  struct extent_info *new_ei;
+
+  while (*p)
+    {
+      pp = *p;
+      ei = rb_entry (*p, struct extent_info, ei_node);
+
+      if (fe_physical < ei->ei_physical)
+        p = &(*p)->rb_left;
+      else if (fe_physical > ei->ei_physical)
+        p = &(*p)->rb_right;
+      else
+        assert (0);
+    }
+
+  new_ei = xcalloc (1, sizeof *ei);
+  new_ei->ei_physical = fe_physical;
+  new_ei->ei_length = fe_length;
+  new_ei->ei_shared_count = extent_shared_count;
+  new_node = &new_ei->ei_node;
+
+  rb_link_node (new_node, pp, p);
+  rb_insert_color (new_node, &fe_root);
+
+  /* We only try to merge the extents info which shared count > 0.  */
+  if (extent_shared_count > 0)
+    {
+      /* Try to merge to the left node.  */
+      node = rb_prev (new_node);
+      if (node)
+        {
+          ei = rb_entry (node, struct extent_info, ei_node);
+          if (mergable_extent_info (ei, new_ei))
+            {
+              new_ei->ei_physical = ei->ei_physical;
+              new_ei->ei_length += ei->ei_length;
+              rb_erase (node, &fe_root);
+              free (ei);
+            }
+        }
+
+      /* Try to merge to the right node.  */
+      node = rb_next (new_node);
+      if (node)
+        {
+          ei = rb_entry (node, struct extent_info, ei_node);
+          if (mergable_extent_info (new_ei, ei))
+            {
+              new_ei->ei_length += ei->ei_length;
+              rb_erase (node, &fe_root);
+              free (ei);
+            }
+        }
+    }
+}
+
+/* Search and return the leftmost node from our rbtree whose
+   physical offset is less than the referenced.  If there is
+   no such record, return the left most one.
+   split_extent() uses its physical offset and extent length
+   as the comparative judgement to determine how to do extent
+   splitting.  */
+
+static struct rb_node *
+lookup_leftmost_extent_info (uint64_t fe_physical)
+{
+  struct rb_node **p = &((&fe_root)->rb_node);
+  struct rb_node *parent = NULL;
+  struct rb_node *prev = NULL;
+  struct extent_info *ei;
+
+  while (*p)
+    {
+      parent = *p;
+      ei = rb_entry (*p, struct extent_info, ei_node);
+
+      if (fe_physical < ei->ei_physical)
+        p = &(*p)->rb_left;
+      else if (fe_physical < ei->ei_physical)
+        p = &(*p)->rb_right;
+      else
+        return parent;
+    }
+
+  /* Return the previous node of parent if the search returned is at
+     the left of parent.  If there is no previous node of parent, return
+     parent.  */
+  if (parent)
+    {
+      ei = rb_entry (parent, struct extent_info, ei_node);
+      if (fe_physical < ei->ei_physical)
+        prev = rb_prev (parent);
+    }
+
+  return prev ? prev : parent;
+}
+
+/* Split the new extent_info into mutiple items if there is overlap
+   with the search returned, insert each item or increase the
+   existed items shared count for the shared part.  */
+
+static void
+split_extent (uint64_t fe_physical, uint64_t fe_length)
+{
+  struct extent_info *ei;
+  struct rb_node *node = NULL;
+  struct rb_node *prev_node = NULL;
+  uint64_t physical_start = fe_physical;
+  uint64_t extent_length = fe_length;
+  uint64_t new_physical_start;
+  uint64_t new_extent_length;
+  uint64_t old_extent_length;
+  size_t extent_shared_count = 0;
+  size_t old_extent_shared_count = 0;
+
+  node = lookup_leftmost_extent_info (physical_start);
+
+  /* We make use of the extent physical offset as the comparative value
+     by combine with the extent length to decide how to split it into
+     sub extents. For each new extent, in short, there are 3 scenarios
+     need to process against the search returned:
+     . physical offset smaller than the searched.
+     . physical offset equal to the searched.
+     . physical offset greater than the searched.  */
+  while (extent_length > 0)
+    {
+      if (! node)
+        {
+          insert_extent_info (prev_node, physical_start, extent_length, extent_shared_count);
+          break;
+        }
+
+      ei = rb_entry (node, struct extent_info, ei_node);
+
+      /* The new extent physical offset is smaller than the search returned.
+         there are three scenarios need to check against the old one which shown
+         as the following sketch.
+                  |---------| old
+         |------| new1
+         |---------------| new2
+         |------------------------| new3.  */
+      if (physical_start < ei->ei_physical)
+        {
+          new_extent_length = MIN (ei->ei_physical - physical_start, extent_length);
+
+          extent_shared_count = 0;
+
+          insert_extent_info (node, physical_start, new_extent_length, extent_shared_count);
+
+          physical_start += new_extent_length;
+          extent_length -= new_extent_length;
+
+          /* Make use of the old parent for the next round checking.  */
+          continue;
+        }
+
+      /* The new extent physical offset if equal to the search returned.
+         there are three scenarios need to check against the old one which shown
+         as the following sketch.
+         |----------| old
+         |----------------| new1
+         |----------| new2
+         |-------| new3.  */
+      if (physical_start == ei->ei_physical)
+        {
+          old_extent_length = ei->ei_length;
+          old_extent_shared_count = ei->ei_shared_count;
+          new_extent_length = MIN (extent_length, ei->ei_length);
+
+          /* Decrease the existed extent size to the minor,
+             and increase the shared count due to the overlap
+             of them.  */
+          ei->ei_length = new_extent_length;
+          ei->ei_shared_count++;
+
+          physical_start += new_extent_length;
+          extent_length -= new_extent_length;
+
+          /* The search returned extent range includes the new one,
+             figure out the not included extent and insert it to rbtree.  */
+          if (old_extent_length > new_extent_length)
+            {
+              new_physical_start = ei->ei_physical + new_extent_length;
+              new_extent_length = old_extent_length - new_extent_length;
+              extent_shared_count = old_extent_shared_count;
+
+              insert_extent_info (node, new_physical_start, new_extent_length, extent_shared_count);
+            }
+
+          prev_node = node;
+          node = rb_next (node);
+          continue;
+        }
+
+      /* The new extent physical offset if greater than the search returned.
+         there are three scenarios need to check against the old one which shown
+         as the following sketch.
+         |-----------| old
+           |----| new1
+           |-----------| new2
+           |---------------| new3.  */
+      if (physical_start < ei->ei_physical + ei->ei_length)
+        {
+          old_extent_length = ei->ei_physical + ei->ei_length - physical_start;
+          new_extent_length = MIN (extent_length, old_extent_length);
+
+          /* The new extent overlapped with the old one, as a result, we
+             need to increase its shared count before inserting.  */
+          extent_shared_count = ei->ei_shared_count + 1;
+          insert_extent_info (node, physical_start, new_extent_length, extent_shared_count);
+
+          /* Decrease the search returned extent size and keep it on the tree.  */
+          ei->ei_length = physical_start - ei->ei_physical;
+
+          physical_start += new_extent_length;
+          extent_length -= new_extent_length;
+          continue;
+        }
+
+      /* Now physical_start >= ei->ei_physical + ei->ei_length, so let
+         rb_next() handle it.  */
+      prev_node = node;
+      node = rb_next (node);
+    }
+}
+
+/* This function is called once for every file system object that fts
+   encounters, get its extent mapping info for the proceeding extent
+   spliting operation.  */
+
+static void
+process_extent (int cwd_fd, char const *file,
+                char const *file_full_name)
+{
+  union { struct fiemap f; char c[4096]; } fiemap_buf;
+  struct fiemap *fiemap = &fiemap_buf.f;
+  struct fiemap_extent *fm_extents = &fiemap->fm_extents[0];
+  enum { count = (sizeof fiemap_buf - sizeof *fiemap) / sizeof *fm_extents };
+  verify (count != 0);
+  bool last = false;
+  int i;
+
+  int fd = openat (cwd_fd, file, O_RDONLY);
+  if (fd < 0)
+    {
+      fd = open (file_full_name, O_RDONLY);
+      if (fd < 0)
+        {
+          error(0, errno, _("cannot open %s"), quote (file_full_name));
+          return;
+	}
+    }
+
+  memset (&fiemap_buf, 0, sizeof fiemap_buf);
+
+  do {
+    fiemap->fm_length = ~0ULL;
+    fiemap->fm_extent_count = count;
+
+    if (ioctl (fd, FS_IOC_FIEMAP, fiemap) < 0)
+      {
+        error (0, errno, _("%s FIEMAP ioctl failed"), quote (file_full_name));
+        goto close_file;
+      }
+
+    /* If 0 extents are returned, then more ioctls
+       are not needed.  */
+    if (fiemap->fm_mapped_extents == 0)
+      goto close_file;
+
+    for (i = 0; i < fiemap->fm_mapped_extents; i++)
+      {
+        uint64_t ext_phy_offset = fm_extents[i].fe_physical;
+        uint64_t ext_len = fm_extents[i].fe_length;
+
+        /* Skip inline file which its data mixed with metadata.  */
+        if (fm_extents[i].fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+          {
+            if (fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST)
+              {
+                last = true;
+                break;
+              }
+            continue;
+          }
+
+        /* Increase the shared extents size per file.  */
+        if (fm_extents[i].fe_flags & FIEMAP_EXTENT_SHARED)
+          file_shared_extents += fm_extents[i].fe_length;
+
+        split_extent (ext_phy_offset, ext_len);
+
+        if (fm_extents[i].fe_flags & FIEMAP_EXTENT_LAST)
+          last = true;
+      }
+
+    /* Do not calculate the next fiemap start offset if only one
+       extent mapped and it is inline.  */
+    if (0 < i)
+      fiemap->fm_start = (fm_extents[i-1].fe_logical + fm_extents[i-1].fe_length);
+
+  } while (! last);
+
+close_file:
+  if (close (fd) < 0)
+    error (0, errno, _("closing %s"), quote (file_full_name));
+}
+
 /* This function is called once for every file system object that fts
    encounters.  fts does a depth-first traversal.  This function knows
    that and accumulates per-directory totals based on changes in
@@ -483,7 +927,8 @@ process_file (FTS *fts, FTSENT *ent)
   static struct dulevel *dulvl;
   bool print = true;
 
-  const char *file = ent->fts_path;
+  const char *file_full_name = ent->fts_path;
+  const char *file = ent->fts_accpath;
   const struct stat *sb = ent->fts_statp;
   bool skip;
 
@@ -495,18 +940,18 @@ process_file (FTS *fts, FTSENT *ent)
   switch (ent->fts_info)
     {
     case FTS_NS:
-      error (0, ent->fts_errno, _("cannot access %s"), quote (file));
+      error (0, ent->fts_errno, _("cannot access %s"), quote (file_full_name));
       return false;
 
     case FTS_ERR:
       /* if (S_ISDIR (ent->fts_statp->st_mode) && FIXME */
-      error (0, ent->fts_errno, _("%s"), quote (file));
+      error (0, ent->fts_errno, _("%s"), quote (file_full_name));
       return false;
 
     case FTS_DNR:
       /* Don't return just yet, since although the directory is not readable,
 	 we were able to stat it, so we do have a size.  */
-      error (0, ent->fts_errno, _("cannot read directory %s"), quote (file));
+      error (0, ent->fts_errno, _("cannot read directory %s"), quote (file_full_name));
       ok = false;
       break;
 
@@ -619,9 +1064,12 @@ process_file (FTS *fts, FTSENT *ent)
   if (!print)
     return ok;
 
+  if (print_shared_size)
+    process_extent (fts->fts_cwd_fd, file, file_full_name);
+
   if ((IS_DIR_TYPE (ent->fts_info) && level <= max_depth)
       || ((opt_all && level <= max_depth) || level == 0))
-    print_size (&dui_to_print, file);
+    print_size (&dui_to_print, file_full_name);
 
   return ok;
 }
@@ -709,7 +1157,7 @@ main (int argc, char **argv)
   human_output_opts = human_options (getenv ("DU_BLOCK_SIZE"), false,
 				     &output_block_size);
 
-  while ((c = getopt_long (argc, argv, DEBUG_OPT "0abchHklmsxB:DLPSX:",
+  while ((c = getopt_long (argc, argv, DEBUG_OPT "0abchHklmsxB:DELPSX:",
 			   long_options, NULL)) != -1)
     {
       switch (c)
@@ -834,6 +1282,13 @@ main (int argc, char **argv)
 	    }
 	  break;
 
+        case 'E':
+#ifndef FS_IOC_FIEMAP
+          error (EXIT_FAILURE, 0, _("Shared-du are not supported by this version"));
+#endif
+          print_shared_size = true;
+          break;
+
 	case FILES0_FROM_OPTION:
 	  files_from = optarg;
 	  break;
@@ -866,6 +1321,9 @@ main (int argc, char **argv)
   if (!ok)
     usage (EXIT_FAILURE);
 
+  if (print_shared_size)
+    fe_root = RB_ROOT;
+
   if (opt_all & opt_summarize_only)
     {
       error (0, 0, _("cannot both summarize and show all entries"));
@@ -1015,6 +1473,15 @@ main (int argc, char **argv)
   if (files_from)
     readtokens0_free (&tok);
 
+  if (print_shared_size)
+    {
+      uintmax_t tot_shared_extent = figure_up_shared_extent ();
+      uintmax_t footprint = tot_dui.size - tot_shared_extent;
+
+      print_footprint(&tot_dui, footprint, _("footprint"));
+      free_extent_info ();
+    }
+
   hash_free (htab);
 
   exit (ok ? EXIT_SUCCESS : EXIT_FAILURE);
-- 
1.5.4.3
