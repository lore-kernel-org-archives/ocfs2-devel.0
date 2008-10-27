From: Tao Ma <tao.ma@oracle.com>
Date: Mon, 27 Oct 2008 16:43:52 +0800
Subject: [Ocfs2-devel] ocfs2: add security EA support v4
In-Reply-To: <49057BE4.208@oracle.com>
References: <49057BE4.208@oracle.com>
Message-ID: <49057F48.1090505@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi tiger,
	I am still working on the patch of "merge xattr set transaction" 
according to Joel's review advice, but I will not modify the interface. 
So feel free to use it.

Regards,
Tao

Tiger Yang wrote:
> Hi,
> I split the previous support security EA patch into four patches for 
> review. Them besed on joel's xattr-28 branch and tao's patch "Merge 
> xattr set transaction".
> 
> 1: move new_inode out of the transaction.
> 2: add ocfs2_xattr_set_handle.
> 3: add security xattr APIs
> 4: add init_security in mknod.
> 
> Best regards,
> tiger
> 
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
