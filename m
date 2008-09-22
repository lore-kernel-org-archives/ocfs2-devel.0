From: Andrew Beekhof <beekhof@gmail.com>
Date: Mon, 22 Sep 2008 16:16:04 +0200
Subject: [Ocfs2-devel] [PATCH] ocfs2console: Allow ocfs2console to enumerate
	device mapper devices
Message-ID: <26ef5e70809220716q7955dfb9g456937f02a0f821@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi,

Jeff delegated the submission of this patch to me :-)

Andrew

From: Jeff Mahoney <jeffm@suse.com>
Subject: ocfs2console: Allow ocfs2console to enumerate device mapper devices
References: bnc#414756

 ocfs2console will currently display device mapper devices as dm-#, where
 the number can be dynamic across reboots making it non-obvious which
 device the user is using. While LVM volumes aren't safe to use across
 physical nodes, they are often used with virtual machines. Many ocfs2
 users also use dm-multipath.

 This patch refactors partition_info_fill to separate hashing from
 enumeration so that it is trivial to add a device-mapper enumerator.

 The device mapper enumerator is automatically enabled if libdevmapper
 is present at build time. When enabled, it suppresses the dm-# devices
 from enumeration. If disabled, the dm-# devices are used instead.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---
 Config.make.in                          |    2
 configure.in                            |    5 +
 ocfs2console/ocfs2interface/Makefile    |    7 +
 ocfs2console/ocfs2interface/ocfsplist.c |  148 ++++++++++++++++++++++----------
 4 files changed, 118 insertions(+), 44 deletions(-)

--- a/Config.make.in
+++ b/Config.make.in
@@ -72,6 +72,8 @@ HAVE_BLKID = @HAVE_BLKID@

 LIBDLM_FOUND = @LIBDLM_FOUND@

+LIBDEVMAPPER_FOUND = @LIBDEVMAPPER_FOUND@
+
 BUILD_OCFS2CONSOLE = @BUILD_OCFS2CONSOLE@

 BUILD_DEBUGOCFS2 = @BUILD_DEBUGOCFS2@
--- a/configure.in
+++ b/configure.in
@@ -289,6 +289,11 @@ if test "x$cman_found" = "xyes" -a "x$cp
 fi
 AC_SUBST(BUILD_CMAN_SUPPORT)

+LIBDEVMAPPER_FOUND=
+AC_CHECK_HEADER(libdevmapper.h, LIBDEVMAPPER_FOUND=yes,
+  [AC_MSG_WARN([libdevmapper.h not found, device-mapper support will
not be built])])
+AC_SUBST(LIBDEVMAPPER_FOUND)
+
 BUILD_OCFS2CONSOLE=
 AC_ARG_ENABLE(ocfs2console, [  --enable-ocfs2console=[yes/no]
Build GUI frontend [default=yes]],,enable_ocfs2console=yes)

--- a/ocfs2console/ocfs2interface/Makefile
+++ b/ocfs2console/ocfs2interface/Makefile
@@ -48,6 +48,11 @@ OCFS2_CFILES = ocfs2module.c
 ocfs2module_CPPFLAGS = $(OCFS2_CPPFLAGS)
 ocfs2module_CFLAGS = $(PYMOD_CFLAGS)

+ifneq ($(LIBDEVMAPPER_FOUND),)
+ocfsplist_CPPFLAGS += -DHAVE_DEVICE_MAPPER
+LIBDEVMAPPER_LIBS = -ldevmapper
+endif
+
 PLIST_OBJS = $(subst .c,.o,$(PLIST_CFILES))
 GIDLE_OBJS = $(subst .c,.o,$(GIDLE_CFILES))
 OCFS2_OBJS = $(subst .c,.o,$(OCFS2_CFILES))
@@ -90,7 +95,7 @@ INSTALL_RULES = install-pylib
 DIST_FILES = $(PLIST_CFILES) $(PLIST_HFILES) $(GIDLE_CFILES)
$(OCFS2_CFILES) $(O2CB_CFILES) $(PYSRC) $(addsuffix
.in,$(BUILT_PYSRC))

 plistmodule.so: $(PLIST_OBJS) $(LIBOCFS2_DEPS) $(LIBO2DLM_DEPS)
$(LIBO2CB_DEPS) $(BLKID_DEPS)
-	$(LINK) -shared $(LIBOCFS2_LIBS) $(LIBO2DLM_LIBS) $(LIBO2CB_LIBS)
$(BLKID_LIBS) $(COM_ERR_LIBS) $(GLIB_LIBS)
+	$(LINK) -shared $(LIBOCFS2_LIBS) $(LIBO2DLM_LIBS) $(LIBO2CB_LIBS)
$(BLKID_LIBS) $(COM_ERR_LIBS) $(GLIB_LIBS) $(LIBDEVMAPPER_LIBS)

 gidlemodule.so: $(GIDLE_OBJS)
 	$(LINK) -shared $(GLIB_LIBS)
--- a/ocfs2console/ocfs2interface/ocfsplist.c
+++ b/ocfs2console/ocfs2interface/ocfsplist.c
@@ -37,6 +37,11 @@

 #include <blkid/blkid.h>

+#ifdef HAVE_DEVICE_MAPPER
+#include <libdevmapper.h>
+#include <limits.h>
+#endif
+
 #include "ocfsplist.h"


@@ -214,15 +219,91 @@ get_device_fstype (const gchar  *device,
 }

 static void
-partition_info_fill (GHashTable *info,
-		     gboolean    async)
+partition_add_one(GHashTable *info, gboolean async, const char *name,
+		  guint *count)
+{
+  GSList *list = NULL;
+  gchar *device = g_strconcat ("/dev/", name, NULL);
+  gint i = strlen (device) - 1;
+
+  if (g_ascii_isdigit (device[i]))
+    {
+      gchar *p;
+      while (i > 0 && g_ascii_isdigit (device[i]))
+        i--;
+
+      p = g_strndup (device, i + 1);
+      list = g_hash_table_lookup (info, p);
+
+      if (list == NULL)
+        {
+          list = g_slist_prepend (NULL, device);
+          g_hash_table_insert (info, p, list);
+        }
+      else
+        {
+          if (strcmp (p, list->data) == 0)
+            {
+              g_free (list->data);
+              list->data = device;
+            }
+          else
+            g_slist_append (list, device);
+
+          g_free (p);
+        }
+    }
+  else if (!g_hash_table_lookup (info, device))
+    {
+      list = g_slist_prepend (NULL, g_strdup (device));
+      g_hash_table_insert (info, device, list);
+    }
+      else
+  g_free (device);
+
+  async_loop_run (async, count, FILL_ASYNC_ITERATIONS);
+}
+
+#ifdef HAVE_DEVICE_MAPPER
+static void
+partition_add_dm(GHashTable *info, gboolean async, guint *count)
+{
+  struct dm_names *names;
+  struct dm_task *dmt;
+  unsigned int next = 0;
+
+  if (!(dmt = dm_task_create(DM_DEVICE_LIST)))
+    return;
+
+  if (!dm_task_run(dmt))
+    goto out;
+
+  if (!(names = dm_task_get_names(dmt)))
+    goto out;
+
+  if (!names->dev)
+    goto out;
+
+  do
+    {
+      char name[PATH_MAX];
+      names = (void *) names + next;
+      snprintf(name, PATH_MAX, "mapper/%s", names->name);
+      partition_add_one(info, async, name, count);
+      next = names->next;
+    }
+  while (next);
+
+out:
+  dm_task_destroy(dmt);
+}
+#endif
+
+static void
+partition_add_partitions(GHashTable *info, gboolean async, guint *count)
 {
   FILE   *proc;
-  gchar   line[100], name[100], *device;
-  GSList *list;
-  gint    i;
-  gchar  *p;
-  guint   count = 0;
+  gchar   line[100], name[100];

   proc = fopen ("/proc/partitions", "r");
   if (proc == NULL)
@@ -233,47 +314,28 @@ partition_info_fill (GHashTable *info,
       if (sscanf(line, "%*d %*d %*d %99[^ \t\n]", name) != 1)
 	continue;

-      device = g_strconcat ("/dev/", name, NULL);
-
-      i = strlen (device) - 1;
-      if (g_ascii_isdigit (device[i]))
-	{
-	  while (i > 0 && g_ascii_isdigit (device[i]))
-	    i--;
+#ifdef HAVE_DEVICE_MAPPER
+      if (strstr(name, "dm-") == name)
+	continue;
+#endif

-	  p = g_strndup (device, i + 1);
-	  list = g_hash_table_lookup (info, p);
+      partition_add_one(info, async, name, count);

-	  if (list == NULL)
-	    {
-	      list = g_slist_prepend (NULL, device);
-	      g_hash_table_insert (info, p, list);
-	    }
-	  else
-	    {
-	      if (strcmp (p, list->data) == 0)
-		{
-		  g_free (list->data);
-		  list->data = device;
-		}
-	      else
-		g_slist_append (list, device);
+    }
+  fclose (proc);
+}

-	      g_free (p);
-	    }
-	}
-      else if (!g_hash_table_lookup (info, device))
-	{
-	  list = g_slist_prepend (NULL, g_strdup (device));
-	  g_hash_table_insert (info, device, list);
-	}
-      else
-	g_free (device);
+static void
+partition_info_fill (GHashTable *info,
+		     gboolean    async)
+{
+  guint   count = 0;

-      async_loop_run (async, &count, FILL_ASYNC_ITERATIONS);
-    }
+  partition_add_partitions(info, async, &count);

-  fclose (proc);
+#ifdef HAVE_DEVICE_MAPPER
+  partition_add_dm(info, async, &count);
+#endif
 }

 static gboolean
