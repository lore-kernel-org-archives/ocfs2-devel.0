From: Christoph Hellwig <hch@lst.de>
Date: Sat,  3 Oct 2015 15:32:37 +0200
Subject: [Ocfs2-devel] [PATCH 01/23] configfs: add show and store methods to
	struct configfs_attribute
In-Reply-To: <1443879179-22280-1-git-send-email-hch@lst.de>
References: <1443879179-22280-1-git-send-email-hch@lst.de>
Message-ID: <1443879179-22280-2-git-send-email-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Tejun Heo <tj@kernel.org>, Pratyush Anand <pratyush.anand@gmail.com>, Pantelis Antoniou <pantelis.antoniou@konsulko.com>, target-devel@vger.kernel.org, cluster-devel@redhat.com, ocfs2-devel@oss.oracle.com, linux-usb@vger.kernel.org, netdev@vger.kernel.org

Add methods to struct configfs_attribute to directly show and store
attributes without adding boilerplate code to every user.  In addition
to the methods this also adds 3 helper macros to define read/write,
read-only and write-only attributes with a single line of code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nicholas Bellinger <nab@linux-iscsi.org>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/configfs/file.c       | 17 ++++++++++++-----
 include/linux/configfs.h | 27 +++++++++++++++++++++++++++
 2 files changed, 39 insertions(+), 5 deletions(-)

diff --git a/fs/configfs/file.c b/fs/configfs/file.c
index 403269f..106ca58 100644
--- a/fs/configfs/file.c
+++ b/fs/configfs/file.c
@@ -74,7 +74,11 @@ static int fill_read_buffer(struct dentry * dentry, struct configfs_buffer * buf
 	if (!buffer->page)
 		return -ENOMEM;
 
-	count = ops->show_attribute(item,attr,buffer->page);
+	if (ops->show_attribute)
+		count = ops->show_attribute(item, attr, buffer->page);
+	else
+		count = attr->show(item, buffer->page);
+
 	buffer->needs_read_fill = 0;
 	BUG_ON(count > (ssize_t)SIMPLE_ATTR_SIZE);
 	if (count >= 0)
@@ -173,7 +177,9 @@ flush_write_buffer(struct dentry * dentry, struct configfs_buffer * buffer, size
 	struct config_item * item = to_item(dentry->d_parent);
 	struct configfs_item_operations * ops = buffer->ops;
 
-	return ops->store_attribute(item,attr,buffer->page,count);
+	if (ops->store_attribute)
+		return ops->store_attribute(item, attr, buffer->page, count);
+	return attr->store(item, buffer->page, count);
 }
 
 
@@ -237,8 +243,8 @@ static int check_perm(struct inode * inode, struct file * file)
 	 * and we must have a store method.
 	 */
 	if (file->f_mode & FMODE_WRITE) {
-
-		if (!(inode->i_mode & S_IWUGO) || !ops->store_attribute)
+		if (!(inode->i_mode & S_IWUGO) ||
+		    (!ops->store_attribute && !attr->store))
 			goto Eaccess;
 
 	}
@@ -248,7 +254,8 @@ static int check_perm(struct inode * inode, struct file * file)
 	 * must be a show method for it.
 	 */
 	if (file->f_mode & FMODE_READ) {
-		if (!(inode->i_mode & S_IRUGO) || !ops->show_attribute)
+		if (!(inode->i_mode & S_IRUGO) ||
+		    (!ops->show_attribute && !attr->show))
 			goto Eaccess;
 	}
 
diff --git a/include/linux/configfs.h b/include/linux/configfs.h
index 63a36e8..85e9956 100644
--- a/include/linux/configfs.h
+++ b/include/linux/configfs.h
@@ -125,8 +125,35 @@ struct configfs_attribute {
 	const char		*ca_name;
 	struct module 		*ca_owner;
 	umode_t			ca_mode;
+	ssize_t (*show)(struct config_item *, char *);
+	ssize_t (*store)(struct config_item *, const char *, size_t);
 };
 
+#define CONFIGFS_ATTR(_pfx, _name)			\
+static struct configfs_attribute _pfx##attr_##_name = {	\
+	.ca_name	= __stringify(_name),		\
+	.ca_mode	= S_IRUGO | S_IWUSR,		\
+	.ca_owner	= THIS_MODULE,			\
+	.show		= _pfx##_name##_show,		\
+	.store		= _pfx##_name##_store,		\
+}
+
+#define CONFIGFS_ATTR_RO(_pfx, _name)			\
+static struct configfs_attribute _pfx##attr_##_name = {	\
+	.ca_name	= __stringify(_name),		\
+	.ca_mode	= S_IRUGO,			\
+	.ca_owner	= THIS_MODULE,			\
+	.show		= _pfx##_name##_show,		\
+}
+
+#define CONFIGFS_ATTR_WO(_pfx, _name)			\
+static struct configfs_attribute _pfx##attr_##_name = {	\
+	.ca_name	= __stringify(_name),		\
+	.ca_mode	= S_IWUSR,			\
+	.ca_owner	= THIS_MODULE,			\
+	.store		= _pfx##_name##_store,		\
+}
+
 /*
  * Users often need to create attribute structures for their configurable
  * attributes, containing a configfs_attribute member and function pointers
-- 
1.9.1
