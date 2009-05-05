From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 05 May 2009 09:40:31 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2: Don't print error when listing too
	many xattrs.
In-Reply-To: <20090504170624.GC31249@mail.oracle.com>
References: <1241385489-24389-1-git-send-email-tao.ma@oracle.com>
	<20090504170624.GC31249@mail.oracle.com>
Message-ID: <49FF990F.4020308@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

Joel Becker wrote:
> On Mon, May 04, 2009 at 05:18:09AM +0800, Tao Ma wrote:
>> Currently, when listing xattrs, kernel define XATTR_LIST_MAX as 65536
>> in include/linux/limits.h, so it can't handle too many xattrs.
>>
>> But with ocfs2 xattr tree, we actually have no limit for the number.
>> And it will pollute the message with something like this when listing.
>> (27738,0):ocfs2_iterate_xattr_buckets:3158 ERROR: status = -34
>> (27738,0):ocfs2_xattr_tree_list_index_block:3264 ERROR: status = -34
>>
>> So don't print "ERROR" message as this is not an ocfs2 error.
> 
> 	Hmm, but this will stop iteration of the xattrs right where we
> hit the large one.  I don't think that's correct.  At the very least, we
> should go on listing with the following xattrs.
> 	Now, the xattr with a too-long name - should we skip it, or
> should we list a truncated name?  That I'm not sure of.
I think we should stop at where we are, return errors and let the user 
space handle this.

Just give you an example.
1. for((i=0;i<20000;i++))do setfattr -n "user.name$i" -v "aaaaa" 
/mnt/ocfs2/a;done
This will create a very long name list.

2. getfattr /mnt/ocfs2/a
/mnt/ocfs2/a: Argument list too long
So you see it says clearly that the name list is too long.
and the same goes for listxattr(2).
If the size of the list buffer is too small to hold the result, errno is 
set to ERANGE.

But if you go ahead and don't return errors. we will get a name list of 
about ~5000 xattrs and no error is returned. So the user may wonder why 
I set 20000 xattrs, but only get 5000 xattrs and look@this as a bug.

Regards,
Tao
