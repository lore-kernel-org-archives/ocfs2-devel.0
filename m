From: Jie Liu <jeff.liu@oracle.com>
Date: Mon, 20 Sep 2010 15:11:31 +0800
Subject: [Ocfs2-devel] [PATCH 1/3] shared-du: add the rbtree source and
	header file to lib v4
In-Reply-To: <>
References: <>
Message-ID: <1284966691-24902-1-git-send-email-jeff.liu@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Add the rbtree stuff to lib.

* lib/rbtree.c: Source file of rbtree.
* lib/rbtree.h: Header file of rbtree.
* lib/Makefile.am (libcoreutils_a_SOURCES): Add both of them.
* lib/Makefile.in (libcoreutils_a_SOURCES): Add both of them for workaround.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
 coreutils-6.9/lib/Makefile.am |    3 +-
 coreutils-6.9/lib/Makefile.in |    4 +-
 coreutils-6.9/lib/rbtree.c    |  403 +++++++++++++++++++++++++++++++++++++++++
 coreutils-6.9/lib/rbtree.h    |  143 +++++++++++++++
 4 files changed, 550 insertions(+), 3 deletions(-)
 create mode 100644 coreutils-6.9/lib/rbtree.c
 create mode 100644 coreutils-6.9/lib/rbtree.h

diff --git a/coreutils-6.9/lib/Makefile.am b/coreutils-6.9/lib/Makefile.am
index cfa22be..6e22f65 100644
--- a/coreutils-6.9/lib/Makefile.am
+++ b/coreutils-6.9/lib/Makefile.am
@@ -26,7 +26,8 @@ LDADD = $(noinst_LIBRARIES)
 
 libcoreutils_a_SOURCES += \
   buffer-lcm.c buffer-lcm.h \
-  xmemxfrm.c xmemxfrm.h
+  xmemxfrm.c xmemxfrm.h \
+  rbtree.c rbtree.h
 
 libcoreutils_a_LIBADD += $(LIBOBJS)
 libcoreutils_a_DEPENDENCIES += $(LIBOBJS)
diff --git a/coreutils-6.9/lib/Makefile.in b/coreutils-6.9/lib/Makefile.in
index 772d8f3..29a81c0 100644
--- a/coreutils-6.9/lib/Makefile.in
+++ b/coreutils-6.9/lib/Makefile.in
@@ -213,7 +213,7 @@ am_libcoreutils_a_OBJECTS = allocsa.$(OBJEXT) base64.$(OBJEXT) \
 	xalloc-die.$(OBJEXT) xgethostname.$(OBJEXT) xmemcoll.$(OBJEXT) \
 	xreadlink.$(OBJEXT) xreadlink-with-size.$(OBJEXT) \
 	xstrndup.$(OBJEXT) xstrtoimax.$(OBJEXT) xstrtoumax.$(OBJEXT) \
-	buffer-lcm.$(OBJEXT) xmemxfrm.$(OBJEXT)
+	buffer-lcm.$(OBJEXT) xmemxfrm.$(OBJEXT) rbtree.$(OBJEXT)
 libcoreutils_a_OBJECTS = $(am_libcoreutils_a_OBJECTS)
 LTLIBRARIES = $(noinst_LTLIBRARIES)
 PROGRAMS = $(noinst_PROGRAMS)
@@ -643,7 +643,7 @@ libcoreutils_a_SOURCES = allocsa.h allocsa.c base64.h base64.c \
 	xgethostname.h xgethostname.c xmemcoll.h xmemcoll.c \
 	xreadlink.c xreadlink-with-size.c xstrndup.h xstrndup.c \
 	xstrtoimax.c xstrtoumax.c buffer-lcm.c buffer-lcm.h xmemxfrm.c \
-	xmemxfrm.h
+	xmemxfrm.h rbtree.c rbtree.h
 libcoreutils_a_LIBADD = $(gl_LIBOBJS) @ALLOCA@ $(LIBOBJS)
 libcoreutils_a_DEPENDENCIES = $(gl_LIBOBJS) @ALLOCA@ $(LIBOBJS)
 EXTRA_libcoreutils_a_SOURCES = acl.c acl_entries.c file-has-acl.c \
diff --git a/coreutils-6.9/lib/rbtree.c b/coreutils-6.9/lib/rbtree.c
new file mode 100644
index 0000000..e6d1b7f
--- /dev/null
+++ b/coreutils-6.9/lib/rbtree.c
@@ -0,0 +1,403 @@
+/* -*- mode: c; c-basic-offset: 8; -*-
+ * vim: noexpandtab sw=8 ts=8 sts=0:
+ *
+ * kernel-rbtree.c
+ *
+ * This is imported from the Linux kernel to give us a tested and
+ * portable tree library.
+ */
+/*
+  Red Black Trees
+  (C) 1999  Andrea Arcangeli <andrea@suse.de>
+  (C) 2002  David Woodhouse <dwmw2@infradead.org>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  linux/lib/rbtree.c
+*/
+
+#include "rbtree.h"
+
+static void
+__rb_rotate_left (struct rb_node *node, struct rb_root *root)
+{
+  struct rb_node *right = node->rb_right;
+
+  if ((node->rb_right = right->rb_left))
+    right->rb_left->rb_parent = node;
+  right->rb_left = node;
+
+  if ((right->rb_parent = node->rb_parent))
+    {
+      if (node == node->rb_parent->rb_left)
+        node->rb_parent->rb_left = right;
+      else
+        node->rb_parent->rb_right = right;
+    }
+  else
+    root->rb_node = right;
+    node->rb_parent = right;
+}
+
+static void
+__rb_rotate_right (struct rb_node *node, struct rb_root *root)
+{
+  struct rb_node *left = node->rb_left;
+
+  if ((node->rb_left = left->rb_right))
+    left->rb_right->rb_parent = node;
+  left->rb_right = node;
+
+  if ((left->rb_parent = node->rb_parent))
+    {
+      if (node == node->rb_parent->rb_right)
+        node->rb_parent->rb_right = left;
+      else
+        node->rb_parent->rb_left = left;
+   }
+  else
+    root->rb_node = left;
+
+  node->rb_parent = left;
+}
+
+void
+rb_insert_color (struct rb_node *node, struct rb_root *root)
+{
+  struct rb_node *parent, *gparent;
+
+  while ((parent = node->rb_parent) && parent->rb_color == RB_RED)
+    {
+     gparent = parent->rb_parent;
+
+      if (parent == gparent->rb_left)
+        {
+          {
+            register struct rb_node *uncle = gparent->rb_right;
+            if (uncle && uncle->rb_color == RB_RED)
+             {
+                uncle->rb_color = RB_BLACK;
+                parent->rb_color = RB_BLACK;
+                gparent->rb_color = RB_RED;
+                node = gparent;
+                continue;
+              }
+          }
+
+          if (parent->rb_right == node)
+            {
+              register struct rb_node *tmp;
+              __rb_rotate_left(parent, root);
+              tmp = parent;
+              parent = node;
+              node = tmp;
+            }
+
+        parent->rb_color = RB_BLACK;
+        gparent->rb_color = RB_RED;
+        __rb_rotate_right(gparent, root);
+        }
+      else
+        {
+          {
+            register struct rb_node *uncle = gparent->rb_left;
+            if (uncle && uncle->rb_color == RB_RED)
+              {
+                uncle->rb_color = RB_BLACK;
+                parent->rb_color = RB_BLACK;
+                gparent->rb_color = RB_RED;
+                node = gparent;
+                continue;
+              }
+          }
+
+          if (parent->rb_left == node)
+            {
+              register struct rb_node *tmp;
+              __rb_rotate_right(parent, root);
+              tmp = parent;
+              parent = node;
+              node = tmp;
+            }
+
+          parent->rb_color = RB_BLACK;
+          gparent->rb_color = RB_RED;
+          __rb_rotate_left(gparent, root);
+        }
+    }
+
+  root->rb_node->rb_color = RB_BLACK;
+}
+
+static void
+__rb_erase_color (struct rb_node *node, struct rb_node *parent,
+                  struct rb_root *root)
+{
+  struct rb_node *other;
+
+  while ((!node || node->rb_color == RB_BLACK) && node != root->rb_node)
+    {
+      if (parent->rb_left == node)
+        {
+          other = parent->rb_right;
+          if (other->rb_color == RB_RED)
+            {
+              other->rb_color = RB_BLACK;
+              parent->rb_color = RB_RED;
+              __rb_rotate_left(parent, root);
+              other = parent->rb_right;
+            }
+          if ((!other->rb_left || other->rb_left->rb_color == RB_BLACK) &&
+              (!other->rb_right || other->rb_right->rb_color == RB_BLACK))
+            {
+              other->rb_color = RB_RED;
+              node = parent;
+              parent = node->rb_parent;
+            }
+          else
+            {
+              if (!other->rb_right || other->rb_right->rb_color == RB_BLACK)
+                {
+                  register struct rb_node *o_left;
+                  if ((o_left = other->rb_left))
+                    o_left->rb_color = RB_BLACK;
+                  other->rb_color = RB_RED;
+                  __rb_rotate_right(other, root);
+                  other = parent->rb_right;
+                }
+              other->rb_color = parent->rb_color;
+              parent->rb_color = RB_BLACK;
+              if (other->rb_right)
+                other->rb_right->rb_color = RB_BLACK;
+              __rb_rotate_left(parent, root);
+              node = root->rb_node;
+              break;
+            }
+        }
+      else
+        {
+          other = parent->rb_left;
+          if (other->rb_color == RB_RED)
+            {
+              other->rb_color = RB_BLACK;
+              parent->rb_color = RB_RED;
+              __rb_rotate_right(parent, root);
+              other = parent->rb_left;
+            }
+          if ((!other->rb_left || other->rb_left->rb_color == RB_BLACK) &&
+              (!other->rb_right || other->rb_right->rb_color == RB_BLACK))
+            {
+              other->rb_color = RB_RED;
+              node = parent;
+              parent = node->rb_parent;
+            }
+          else
+            {
+              if (!other->rb_left || other->rb_left->rb_color == RB_BLACK)
+                {
+                  register struct rb_node *o_right;
+                  if ((o_right = other->rb_right))
+                    o_right->rb_color = RB_BLACK;
+                  other->rb_color = RB_RED;
+                  __rb_rotate_left(other, root);
+                  other = parent->rb_left;
+                }
+             other->rb_color = parent->rb_color;
+              parent->rb_color = RB_BLACK;
+
+              if (other->rb_left)
+                other->rb_left->rb_color = RB_BLACK;
+              __rb_rotate_right(parent, root);
+              node = root->rb_node;
+              break;
+            }
+        }
+    }
+  if (node)
+    node->rb_color = RB_BLACK;
+}
+
+void
+rb_erase (struct rb_node *node, struct rb_root *root)
+{
+  struct rb_node *child, *parent;
+  int color;
+
+  if (!node->rb_left)
+    child = node->rb_right;
+  else if (!node->rb_right)
+    child = node->rb_left;
+  else
+    {
+      struct rb_node *old = node, *left;
+
+      node = node->rb_right;
+      while ((left = node->rb_left) != NULL)
+        node = left;
+      child = node->rb_right;
+      parent = node->rb_parent;
+     color = node->rb_color;
+
+      if (child)
+        child->rb_parent = parent;
+      if (parent)
+        {
+          if (parent->rb_left == node)
+            parent->rb_left = child;
+          else
+            parent->rb_right = child;
+        }
+      else
+        root->rb_node = child;
+
+      if (node->rb_parent == old)
+        parent = node;
+      node->rb_parent = old->rb_parent;
+      node->rb_color = old->rb_color;
+      node->rb_right = old->rb_right;
+      node->rb_left = old->rb_left;
+
+      if (old->rb_parent)
+        {
+          if (old->rb_parent->rb_left == old)
+            old->rb_parent->rb_left = node;
+          else
+            old->rb_parent->rb_right = node;
+        } else
+          root->rb_node = node;
+
+      old->rb_left->rb_parent = node;
+      if (old->rb_right)
+        old->rb_right->rb_parent = node;
+      goto color;
+  }
+
+  parent = node->rb_parent;
+  color = node->rb_color;
+
+  if (child)
+    child->rb_parent = parent;
+  if (parent)
+    {
+      if (parent->rb_left == node)
+        parent->rb_left = child;
+      else
+        parent->rb_right = child;
+    }
+  else
+    root->rb_node = child;
+
+color:
+if (color == RB_BLACK)
+  __rb_erase_color(child, parent, root);
+}
+
+/* This function returns the first node (in sort order) of the tree.  */
+struct rb_node *
+rb_first (struct rb_root *root)
+{
+  struct rb_node *n;
+
+  n = root->rb_node;
+  if (!n)
+    return NULL;
+  while (n->rb_left)
+    n = n->rb_left;
+ return n;
+}
+
+struct rb_node *
+rb_last (struct rb_root *root)
+{
+  struct rb_node *n;
+
+  n = root->rb_node;
+  if (!n)
+    return NULL;
+  while (n->rb_right)
+    n = n->rb_right;
+  return n;
+}
+
+struct rb_node *
+rb_next (struct rb_node *node)
+{
+  /* If we have a right-hand child, go down and then left as far
+     as we can.  */
+  if (node->rb_right)
+    {
+      node = node->rb_right;
+      while (node->rb_left)
+        node=node->rb_left;
+      return node;
+    }
+
+  /* No right-hand children.  Everything down and left is
+     smaller than us, so any 'next' node must be in the general
+     direction of our parent. Go up the tree; any time the
+     ancestor is a right-hand child of its parent, keep going
+     up. First time it's a left-hand child of its parent, said
+     parent is our 'next' node.  */
+  while (node->rb_parent && node == node->rb_parent->rb_right)
+    node = node->rb_parent;
+
+  return node->rb_parent;
+}
+
+struct rb_node *
+rb_prev (struct rb_node *node)
+{
+  /* If we have a left-hand child, go down and then right as far
+     as we can.  */
+  if (node->rb_left)
+    {
+      node = node->rb_left;
+      while (node->rb_right)
+        node=node->rb_right;
+      return node;
+    }
+
+  /* No left-hand children.  Go up till we find an ancestor which
+     is a right-hand child of its parent.  */
+  while (node->rb_parent && node == node->rb_parent->rb_left)
+    node = node->rb_parent;
+
+  return node->rb_parent;
+}
+
+void
+rb_replace_node (struct rb_node *victim, struct rb_node *new,
+                 struct rb_root *root)
+{
+  struct rb_node *parent = victim->rb_parent;
+
+  /* Set the surrounding nodes to point to the replacement.  */
+  if (parent) {
+    if (victim == parent->rb_left)
+      parent->rb_left = new;
+    else
+      parent->rb_right = new;
+  } else {
+    root->rb_node = new;
+  }
+
+  if (victim->rb_left)
+    victim->rb_left->rb_parent = new;
+  if (victim->rb_right)
+    victim->rb_right->rb_parent = new;
+
+  /* Copy the pointers/colour from the victim to the replacement.  */
+  *new = *victim;
+}
diff --git a/coreutils-6.9/lib/rbtree.h b/coreutils-6.9/lib/rbtree.h
new file mode 100644
index 0000000..0256919
--- /dev/null
+++ b/coreutils-6.9/lib/rbtree.h
@@ -0,0 +1,143 @@
+/*
+  Red Black Trees
+  (C) 1999  Andrea Arcangeli <andrea@suse.de>
+
+  This program is free software; you can redistribute it and/or modify
+  it under the terms of the GNU General Public License as published by
+  the Free Software Foundation; either version 2 of the License, or
+  (at your option) any later version.
+
+  This program is distributed in the hope that it will be useful,
+  but WITHOUT ANY WARRANTY; without even the implied warranty of
+  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+  GNU General Public License for more details.
+
+  You should have received a copy of the GNU General Public License
+  along with this program; if not, write to the Free Software
+  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
+
+  rbtree.h
+
+  To use rbtrees you'll have to implement your own insert and search cores.
+  This will avoid us to use callbacks and to drop drammatically performances.
+  I know it's not the cleaner way,  but in C (not in C++) to get
+  performances and genericity...
+
+  Some example of insert and search follows here. The search is a plain
+  normal search over an ordered tree. The insert instead must be implemented
+  int two steps: as first thing the code must insert the element in
+  order as a red leaf in the tree, then the support library function
+  rb_insert_color() must be called. Such function will do the
+  not trivial work to rebalance the rbtree if necessary.
+
+-----------------------------------------------------------------------
+static inline struct page * rb_search_page_cache (struct inode * inode,
+						  unsigned long offset)
+{
+  struct rb_node * n = inode->i_rb_page_cache.rb_node;
+  struct page * page;
+
+ while (n)
+    {
+      page = rb_entry (n, struct page, rb_page_cache);
+
+      if (offset < page->offset)
+        n = n->rb_left;
+      else if (offset > page->offset)
+        n = n->rb_right;
+      else
+        return page;
+    }
+  return NULL;
+}
+
+static inline struct page * __rb_insert_page_cache (struct inode * inode,
+						    unsigned long offset,
+						    struct rb_node * node)
+{
+  struct rb_node ** p = &inode->i_rb_page_cache.rb_node;
+  struct rb_node * parent = NULL;
+  struct page * page;
+
+  while (*p)
+    {
+      parent = *p;
+      page = rb_entry (parent, struct page, rb_page_cache);
+
+      if (offset < page->offset)
+        p = &(*p)->rb_left;
+      else if (offset > page->offset)
+        p = &(*p)->rb_right;
+      else
+        return page;
+    }
+
+  rb_link_node (node, parent, p);
+
+  return NULL;
+}
+
+static inline struct page * rb_insert_page_cache (struct inode * inode,
+						  unsigned long offset,
+						  struct rb_node * node)
+{
+  struct page * ret;
+  if ((ret = __rb_insert_page_cache (inode, offset, node)))
+    goto out;
+  rb_insert_color (node, &inode->i_rb_page_cache);
+ out:
+	return ret;
+}
+-----------------------------------------------------------------------
+*/
+
+#ifndef	_LINUX_RBTREE_H
+#define	_LINUX_RBTREE_H
+
+#include <stdlib.h>
+
+struct rb_node
+  {
+    struct rb_node *rb_parent;
+    int rb_color;
+#define	RB_RED    0
+#define	RB_BLACK  1
+    struct rb_node *rb_right;
+    struct rb_node *rb_left;
+  };
+
+struct rb_root
+  {
+    struct rb_node *rb_node;
+  };
+
+#define RB_ROOT	(struct rb_root) { NULL, }
+#define	rb_entry(ptr, type, member) \
+  ((type *)((char *)(ptr)-(unsigned long)(&((type *)0)->member)))
+
+extern void rb_insert_color (struct rb_node *, struct rb_root *);
+extern void rb_erase (struct rb_node *, struct rb_root *);
+
+/* Find logical next and previous nodes in a tree.  */
+extern struct rb_node *rb_next (struct rb_node *);
+extern struct rb_node *rb_prev (struct rb_node *);
+extern struct rb_node *rb_first (struct rb_root *);
+extern struct rb_node *rb_last (struct rb_root *);
+
+/* Fast replacement of a single node without remove/rebalance/add/rebalance.  */
+extern void rb_replace_node (struct rb_node *victim,
+                             struct rb_node *new,
+                             struct rb_root *root);
+
+static inline void rb_link_node (struct rb_node * node,
+                                 struct rb_node * parent,
+                                 struct rb_node ** rb_link)
+{
+  node->rb_parent = parent;
+  node->rb_color = RB_RED;
+  node->rb_left = node->rb_right = NULL;
+
+  *rb_link = node;
+}
+
+#endif	/* _LINUX_RBTREE_H */
-- 
1.5.4.3
