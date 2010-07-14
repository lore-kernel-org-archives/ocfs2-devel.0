From: Tao Ma <tao.ma@oracle.com>
Date: Wed, 14 Jul 2010 22:58:46 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: don't overwrite error codes in
 ocfs2_init_acl
In-Reply-To: <4C3D8D53.7010400@oracle.com>
References: <4C3D8D53.7010400@oracle.com>
Message-ID: <4C3DD0A6.4050902@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Tiger,
Tiger Yang wrote:
> Hi, all,
>
> Pawel(pzlist at mp.pl) reported a bug in ocfs2 acl. This patch fix this 
> issue.
>
> Thanks,
> tiger
@@ -381,7 +381,11 @@ int ocfs2_init_acl(handle_t *handle,

 		mode = inode->i_mode;
 		ret = posix_acl_create_masq(clone, &mode);
 		if (ret >= 0) {
-			ret = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			ret2 = ocfs2_acl_set_mode(inode, di_bh, handle, mode);
+			if (ret2) {
+				mlog_errno(ret2);
You need to set ret = ret2 here so that we can return the error value to the caller.
+				goto cleanup;
+			}
 			if (ret > 0) {
 				ret = ocfs2_set_acl(handle, inode,
 						    di_bh, ACL_TYPE_ACCESS,

Regards,
Tao
