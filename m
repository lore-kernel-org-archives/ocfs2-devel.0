From: Christoph Hellwig <hch@lst.de>
Date: Fri, 25 Sep 2015 06:49:53 -0700
Subject: [Ocfs2-devel] [PATCH 16/23] usb-gadget/f_serial: use per-attribute
	show and store methods
In-Reply-To: <1443189000-13398-1-git-send-email-hch@lst.de>
References: <1443189000-13398-1-git-send-email-hch@lst.de>
Message-ID: <1443189000-13398-17-git-send-email-hch@lst.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joel Becker <jlbec@evilplan.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-usb@vger.kernel.org, netdev@vger.kernel.org, Pratyush Anand <pratyush.anand@gmail.com>, Felipe Balbi <balbi@ti.com>, cluster-devel@redhat.com, target-devel@vger.kernel.org, Tejun Heo <tj@kernel.org>, ocfs2-devel@oss.oracle.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/usb/gadget/function/f_serial.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/gadget/function/f_serial.c b/drivers/usb/gadget/function/f_serial.c
index 1d162e2..ec837f4 100644
--- a/drivers/usb/gadget/function/f_serial.c
+++ b/drivers/usb/gadget/function/f_serial.c
@@ -266,22 +266,6 @@ static inline struct f_serial_opts *to_f_serial_opts(struct config_item *item)
 			    func_inst.group);
 }
 
-CONFIGFS_ATTR_STRUCT(f_serial_opts);
-static ssize_t f_serial_attr_show(struct config_item *item,
-				  struct configfs_attribute *attr,
-				  char *page)
-{
-	struct f_serial_opts *opts = to_f_serial_opts(item);
-	struct f_serial_opts_attribute *f_serial_opts_attr =
-		container_of(attr, struct f_serial_opts_attribute, attr);
-	ssize_t ret = 0;
-
-	if (f_serial_opts_attr->show)
-		ret = f_serial_opts_attr->show(opts, page);
-
-	return ret;
-}
-
 static void serial_attr_release(struct config_item *item)
 {
 	struct f_serial_opts *opts = to_f_serial_opts(item);
@@ -291,19 +275,17 @@ static void serial_attr_release(struct config_item *item)
 
 static struct configfs_item_operations serial_item_ops = {
 	.release	= serial_attr_release,
-	.show_attribute = f_serial_attr_show,
 };
 
-static ssize_t f_serial_port_num_show(struct f_serial_opts *opts, char *page)
+static ssize_t f_serial_port_num_show(struct config_item *item, char *page)
 {
-	return sprintf(page, "%u\n", opts->port_num);
+	return sprintf(page, "%u\n", to_f_serial_opts(item)->port_num);
 }
 
-static struct f_serial_opts_attribute f_serial_port_num =
-	__CONFIGFS_ATTR_RO(port_num, f_serial_port_num_show);
+CONFIGFS_ATTR_RO(f_serial_, port_num);
 
 static struct configfs_attribute *acm_attrs[] = {
-	&f_serial_port_num.attr,
+	&f_serial_attr_port_num,
 	NULL,
 };
 
-- 
1.9.1
