From: Sunil Mushran <sunil.mushran@gmail.com>
Date: Wed, 31 Jul 2013 20:33:48 -0700
Subject: [Ocfs2-devel] Why ocfs2 haven't implemented "steal" for
 local_alloc system files?
In-Reply-To: <51F3A091.4090605@huawei.com>
References: <51F3A091.4090605@huawei.com>
Message-ID: <CAEeiSHVsUGvBRR3iN4TpQqHVN4+KD6aV+e2nEGZ7ouYOWJEhpw@mail.gmail.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Because it makes no sense. Unlike inode/extent allocs, local_alloc is a
temporary cache. If you fail to allocate, you fallback to the global bitmap.


On Sat, Jul 27, 2013 at 3:27 AM, Younger Liu <younger.liu@huawei.com> wrote:

> Hi,
>   While analyzing ocfs2 block allocation, I found:
>   When claiming space from inode_alloc (or extent_alloc) system files,
> if there is no enough space in inode_alloc (or extent_alloc) and
> global_bitmap, it could steal space from other slots.
>   But when claiming space from local_alloc system files, and no
> enough space in local_alloc and global_bitmap, it returns -ENOSPC.
>
>   Why ocfs2 haven't implemented "steal" for local_alloc system files?
>   Is there any some reasons?
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
>
-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20130731/e1a999fb/attachment.html 
