From: Jie Liu <jeff.liu@oracle.com>
Date: Fri, 26 Feb 2010 23:28:28 +0800
Subject: [Ocfs2-devel] [PATCH 3/3] du-enhancement: show the shared extents
	per file and the footprint v2
In-Reply-To: <1267198108-7459-2-git-send-email-jeff.liu@oracle.com>
References: <> <1267198108-7459-1-git-send-email-jeff.liu@oracle.com>
	<1267198108-7459-2-git-send-email-jeff.liu@oracle.com>
Message-ID: <1267198108-7459-3-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

this patch add fiemap feature support in du, du show the shared extents size in parens per file
as well as the footprint for each request with either '--shared-size' or '-E' option.

the footprint which is total minus the sum total of all extents in the rbtree
that have ei_shared_count > 0.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 coreutils-6.9/src/du.c |  444 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 437 insertions(+), 7 deletions(-)

diff --git a/coreutils-6.9/src/du.c b/coreutils-6.9/src/du.c
index 206d318..3adc3a8 100644
--- a/coreutils-6.9/src/du.c
+++ b/coreutils-6.9/src/du.c
@@ -28,6 +28,11 @@
 #include <stdio.h>
 #include <getopt.h>
 #include <sys/types.h>
+
+#if HAVE_SYS_IOCTL_H
+# include <sys/ioctl.h>
+#endif
+
 #include <assert.h>
 #include "system.h"
 #include "argmatch.h"
@@ -44,6 +49,8 @@
 #include "stat-time.h"
 #include "xfts.h"
 #include "xstrtol.h"
+#include "rbtree.h"
+#include "fiemap.h"
 
 extern bool fts_debug;
 
@@ -64,6 +71,10 @@ extern bool fts_debug;
 /* Initial size of the hash table.  */
 #define INITIAL_TABLE_SIZE 103
 
+#if defined(_IOWR) && !defined(FS_IOC_FIEMAP)
+# define FS_IOC_FIEMAP _IOWR('f', 11, struct fiemap)
+#endif
+
 /* Hash structure for inode and device numbers.  The separate entry
    structure makes it easier to rehash "in place".  */
 
@@ -174,6 +185,34 @@ static char const *time_style = NULL;
 /* Format used to display date / time. Controlled by --time-style */
 static char const *time_format = NULL;
 
+/* If true, display the size of the shared extents per file and show
+ * the footprint in the end.  */
+static bool print_shared_size = false;
+
+/* FIEMAP_FLAG_* flags for request.  */
+static uint32_t fiemap_bits_flags;
+
+/* Show the size of the shared extents per file.  */
+static uint64_t file_shared_extents;
+
+/* Initialize the root of extents tree.  */
+static struct rb_root fe_root;
+
+/* A structure for per extent info.  */
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
 /* The units to use when printing sizes.  */
 static uintmax_t output_block_size;
 
@@ -205,7 +244,9 @@ enum
   MEGABYTES_LONG_OPTION,
 
   TIME_OPTION,
-  TIME_STYLE_OPTION
+  TIME_STYLE_OPTION,
+  FIEMAP_FLAG_SYNC_OPTION,
+  FIEMAP_FLAG_XATTR_OPTION
 };
 
 static struct option const long_options[] =
@@ -215,6 +256,9 @@ static struct option const long_options[] =
   {"block-size", required_argument, NULL, 'B'},
   {"bytes", no_argument, NULL, 'b'},
   {"count-links", no_argument, NULL, 'l'},
+  {"shared-size", no_argument, NULL, 'E'},
+  {"fsync", no_argument, NULL, FIEMAP_FLAG_SYNC_OPTION},
+  {"fxattr", no_argument, NULL, FIEMAP_FLAG_XATTR_OPTION},
   {"dereference", no_argument, NULL, 'L'},
   {"dereference-args", no_argument, NULL, 'D'},
   {"exclude", required_argument, NULL, EXCLUDE_OPTION},
@@ -314,6 +358,11 @@ Mandatory arguments to long options are mandatory for short options too.\n\
   -m                    like --block-size=1M\n\
 "), stdout);
       fputs (_("\
+  -E, --shared-size     show the size of the shared extents per file\n\
+      --fsync           sync file data before map\n\
+      --fxattr          map extended attribute tree\n\
+"), stdout);
+      fputs (_("\
   -L, --dereference     dereference all symbolic links\n\
   -P, --no-dereference  don't follow any symbolic links (this is the default)\n\
   -0, --null            end each output line with 0 byte rather than newline\n\
@@ -443,6 +492,22 @@ print_only_size (uintmax_t n_bytes)
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
@@ -454,10 +519,329 @@ print_size (const struct duinfo *pdui, const char *string)
       putchar ('\t');
       show_date (time_format, pdui->tmax);
     }
+  if ((print_shared_size) && (file_shared_extents > 0))
+    {
+      putchar ('\t');
+      putchar ('(');
+
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
 
+/* Free all allocated extents info from the rbtree.  */
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
+/* Walkup the extents rbtree to figure out the total size
+   of shared extents which has ei_shared_count > 0.  */
+
+static uintmax_t
+figure_share_extent_size (void)
+{
+  struct rb_node *node;
+  struct extent_info *ei;
+  static uintmax_t total_shared_extents = 0;
+
+  for (node = rb_first (&fe_root); node; node = rb_next (node))
+  {
+    ei = rb_entry (node, struct extent_info, ei_node);
+    if (ei->ei_shared_count > 0)
+        total_shared_extents += ei->ei_length * ei->ei_shared_count;
+  }
+
+  return total_shared_extents;
+}
+
+/* Insert new extent based on the new parent.  */
+
+static void
+insert_new_extent_info (struct rb_node *parent,
+                        uint64_t fe_physical,
+                        uint64_t fe_length,
+                        size_t extent_shared_count)
+{
+  struct rb_node **p = parent ? &parent : &((&fe_root)->rb_node);
+  struct rb_node *pp = NULL;
+  struct extent_info *this = NULL;
+  struct extent_info *ei;
+
+  while (*p)
+    {
+      pp = *p;
+      this = rb_entry (*p, struct extent_info, ei_node);
+
+      if (this->ei_physical > fe_physical)
+        p = &(*p)->rb_left;
+      else if (this->ei_physical < fe_physical)
+	p = &(*p)->rb_right;
+      else
+	return;
+    }
+
+  ei = xcalloc (1, sizeof *ei);
+  ei->ei_physical = fe_physical;
+  ei->ei_length = fe_length;
+  ei->ei_shared_count += extent_shared_count;
+
+  rb_link_node (&ei->ei_node, pp, p);
+  rb_insert_color (&ei->ei_node, &fe_root);
+}
+
+/* Find the left-most position to insert.  */
+
+static struct rb_node *
+lookup_leftmost_extent_info (uint64_t fe_physical)
+{
+  struct rb_node **p = &((&fe_root)->rb_node);
+  struct rb_node *parent;
+  struct extent_info *this;
+
+  while (*p)
+    {
+      parent = *p;
+      this = rb_entry (*p, struct extent_info, ei_node);
+
+      if (this->ei_physical > fe_physical)
+       p = &(*p)->rb_left;
+      else if (this->ei_physical < fe_physical)
+	p = &(*p)->rb_right;
+      else
+	break;
+    }
+
+  return parent;
+}
+
+/* Split the new extent into mutiple items if there is overlap
+   with the search returned, insert each item or increase the
+   existed items shared count for the shared part.  */
+
+static void
+split_extent (uint64_t extent_physical_offset,
+              uint64_t extent_length)
+{
+  struct rb_node *parent = NULL;
+  struct rb_node *prev_parent = NULL;
+  struct extent_info *this;
+  uint64_t pb_start = extent_physical_offset;
+  uint64_t ext_len = extent_length;
+  uint64_t new_pb_start;
+  uint64_t new_ext_len;
+  uint64_t old_ext_len;
+  size_t ext_shared_count = 0;
+
+  parent = lookup_leftmost_extent_info (pb_start);
+
+  /* We make use of the extent physical offset as the comparative value by combine
+     with the extent length to decide how to split it into sub extents.
+     For each new extent, in short, there are 3 scenarios need to process against
+     the search returned:
+     . physical offset smaller than the searched.
+     . physical offset equal to the searched.
+     . physical offset greater than the searched.  */
+  while (ext_len)
+    {
+      if (!parent)
+        {
+          insert_new_extent_info (prev_parent, pb_start, ext_len, ext_shared_count);
+	  break;
+	}
+
+      this = rb_entry (parent, struct extent_info, ei_node);
+
+      /* The new extent physical offset is smaller than the search returned.
+         there are 3 scenarios need to check against the old one which shown
+	 as the following sketch.
+                   |---------| old
+         |------| new1
+         |---------------| new2
+         |------------------------| new3.  */
+
+      if (pb_start < this->ei_physical)
+	{
+	  new_ext_len = MIN (this->ei_physical - pb_start, ext_len);
+
+	  ext_shared_count = 0;
+          insert_new_extent_info (parent, pb_start, new_ext_len, ext_shared_count);
+
+          pb_start += new_ext_len;
+	  ext_len -= new_ext_len;
+          continue;
+        }
+
+      /* The new extent physical offset if equal to the search returned.
+         there are 3 scenarios need to check against the old one which shown
+	 as the following sketch.
+         |----------| old
+         |----------------| new1
+         |----------| new2
+         |-------| new3.  */
+      if (pb_start == this->ei_physical)
+        {
+          old_ext_len = this->ei_length;
+          new_ext_len = MIN (ext_len, this->ei_length);
+
+          /* Decrease the existed extent size to the minor, its shared count
+	     need to increase due to the overlap of them.  */
+          this->ei_length = new_ext_len;
+          this->ei_shared_count++;
+
+          pb_start += new_ext_len;
+          ext_len -= new_ext_len;
+
+          /* The search returned extent range includes the new, figure out the
+	   * not included range and insert it on the rbtree.  */
+          if (old_ext_len > new_ext_len)
+            {
+	      new_pb_start = this->ei_physical + this->ei_length;
+              new_ext_len = old_ext_len - new_ext_len;
+	      ext_shared_count = 0;
+	      insert_new_extent_info (parent, new_pb_start, new_ext_len, ext_shared_count);
+	    }
+
+          prev_parent = parent;
+          parent = rb_next (parent);
+          continue;
+        }
+
+      /* The new extent physical offset if greater than the search returned.
+         there are 3 scenarios need to check against the old one which shown
+	 as the following sketch.
+         |-----------| old
+           |----| new1
+           |-----------| new2
+           |---------------| new3.  */
+      if (pb_start < this->ei_physical + this->ei_length)
+        {
+	  old_ext_len = this->ei_physical + this->ei_length - pb_start;
+	  new_ext_len = MIN (ext_len, old_ext_len);
+
+          ext_shared_count = this->ei_shared_count;
+
+          /* The new extent overlapped with the old one, as a result, we
+	     need to increase its shared count before inserting.  */
+          ext_shared_count++;
+	  insert_new_extent_info (parent, pb_start, new_ext_len, ext_shared_count);
+
+          /* Decrease the search returned extent size and keep it on the tree.  */
+          this->ei_length = pb_start - this->ei_physical;
+
+	  pb_start += new_ext_len;
+	  ext_len -= new_ext_len;
+          parent = rb_next (parent);
+          continue;
+        }
+
+      prev_parent = parent;
+      parent = rb_next (parent);
+    }
+}
+
+/* This function is called once for every file system object that fts
+   encounters, get its extent mapping info for the proceeding extent
+   spliting operation.  */
+
+static void
+process_extent(int cwd_fd, char const *file,
+               char const *file_full_name)
+{
+  char buf[4096] = "";
+  struct fiemap *fiemap = (struct fiemap *)buf;
+  struct fiemap_extent *fm_ext = &fiemap->fm_extents[0];
+  uint32_t count = (sizeof (buf) - sizeof (*fiemap)) /
+               sizeof (struct fiemap_extent);
+  int last = 0;
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
+  memset (fiemap, 0, sizeof (*fiemap));
+
+  do {
+    fiemap->fm_length = ~0ULL;
+    fiemap->fm_flags = fiemap_bits_flags;
+    fiemap->fm_extent_count = count;
+
+    if (ioctl (fd, FS_IOC_FIEMAP, (unsigned long) fiemap) < 0)
+      {
+        if (errno == EBADR)
+            error (0, errno, _("%s FIEMAP failed with unsupported flags %x\n"),
+                                quote (file_full_name), fiemap->fm_flags);
+
+        error(0, errno, _("%s extent mapping failed"), quote (file_full_name));
+        goto close_file;
+      }
+
+    /* If 0 extents are returned, then more ioctls
+       are not needed.  */
+    if (fiemap->fm_mapped_extents == 0)
+      goto close_file;
+
+    uint64_t ext_phy_offset;
+    uint64_t ext_len;
+    size_t i;
+    for (i = 0; i < fiemap->fm_mapped_extents; i++)
+      {
+        ext_phy_offset = fm_ext[i].fe_physical;
+	ext_len = fm_ext[i].fe_length;
+
+        /* Skip inline file which its data mixed with metadata.  */
+        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_DATA_INLINE)
+	  {
+            if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
+              {
+                last = 1;
+                break;
+	      }
+	    continue;
+	  }
+
+        /* Increase the shared extents size per file.  */
+        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_SHARED)
+          file_shared_extents += fm_ext[i].fe_length;
+
+        split_extent (ext_phy_offset, ext_len);
+
+        if (fm_ext[i].fe_flags & FIEMAP_EXTENT_LAST)
+          last = 1;
+
+        fiemap->fm_start = (fm_ext[i-1].fe_logical + fm_ext[i-1].fe_length);
+      }
+    } while (last == 0);
+
+close_file:
+  if (close (fd) < 0)
+      error (0, errno, _("closing %s"), quote (file_full_name));
+}
+
 /* This function is called once for every file system object that fts
    encounters.  fts does a depth-first traversal.  This function knows
    that and accumulates per-directory totals based on changes in
@@ -483,7 +867,8 @@ process_file (FTS *fts, FTSENT *ent)
   static struct dulevel *dulvl;
   bool print = true;
 
-  const char *file = ent->fts_path;
+  const char *file_full_name = ent->fts_path;
+  const char *file = ent->fts_accpath;
   const struct stat *sb = ent->fts_statp;
   bool skip;
 
@@ -495,18 +880,18 @@ process_file (FTS *fts, FTSENT *ent)
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
 
@@ -619,9 +1004,12 @@ process_file (FTS *fts, FTSENT *ent)
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
@@ -709,7 +1097,7 @@ main (int argc, char **argv)
   human_output_opts = human_options (getenv ("DU_BLOCK_SIZE"), false,
 				     &output_block_size);
 
-  while ((c = getopt_long (argc, argv, DEBUG_OPT "0abchHklmsxB:DLPSX:",
+  while ((c = getopt_long (argc, argv, DEBUG_OPT "0abchHklmsxB:DELPSX:",
 			   long_options, NULL)) != -1)
     {
       switch (c)
@@ -834,6 +1222,27 @@ main (int argc, char **argv)
 	    }
 	  break;
 
+	case 'E':
+#ifndef FS_IOC_FIEMAP
+          error (EXIT_FAILURE, 0, _("Shared-du are not supported by this version"));
+#endif
+	  print_shared_size = true;
+	  break;
+
+	case FIEMAP_FLAG_SYNC_OPTION:
+#ifndef FS_IOC_FIEMAP
+          error (EXIT_FAILURE, 0, _("Shared-du are not supported by this version"));
+#endif
+	  fiemap_bits_flags |= FIEMAP_FLAG_SYNC;
+          break;
+
+        case FIEMAP_FLAG_XATTR_OPTION:
+#ifndef FS_IOC_FIEMAP
+          error (EXIT_FAILURE, 0, _("Shared-du are not supported by this version"));
+#endif
+	  fiemap_bits_flags |= FIEMAP_FLAG_XATTR;
+	  break;
+
 	case FILES0_FROM_OPTION:
 	  files_from = optarg;
 	  break;
@@ -866,6 +1275,17 @@ main (int argc, char **argv)
   if (!ok)
     usage (EXIT_FAILURE);
 
+  if (((fiemap_bits_flags & FIEMAP_FLAG_SYNC) ||
+      (fiemap_bits_flags & FIEMAP_FLAG_XATTR)) &&
+      !print_shared_size)
+    {
+      error(0, 0, _("warning: fiemap flags must be combined with --shared-size"));
+      usage (EXIT_FAILURE);
+    }
+
+  if (print_shared_size)
+      fe_root = RB_ROOT;
+
   if (opt_all & opt_summarize_only)
     {
       error (0, 0, _("cannot both summarize and show all entries"));
@@ -1015,6 +1435,16 @@ main (int argc, char **argv)
   if (files_from)
     readtokens0_free (&tok);
 
+  if (print_shared_size)
+    {
+      uintmax_t tot_shared_extents = figure_share_extent_size ();
+      uintmax_t footprint = tot_dui.size - tot_shared_extents;
+
+      print_footprint(&tot_dui, footprint, _("footprint"));
+
+      free_extent_info ();
+    }
+
   hash_free (htab);
 
   exit (ok ? EXIT_SUCCESS : EXIT_FAILURE);
-- 
1.5.4.3
