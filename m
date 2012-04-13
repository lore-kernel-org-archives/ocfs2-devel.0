From: Tao Ma <tm@tao.ma>
Date: Fri, 13 Apr 2012 17:26:52 +0800
Subject: [Ocfs2-devel] Maybe a null point bug in
	__ocfs2_change_file_space.
In-Reply-To: <6A84A23BB58148AEAFD0504349CC2A0D@c00148h>
References: <6A84A23BB58148AEAFD0504349CC2A0D@c00148h>
Message-ID: <4F87F15C.9080009@tao.ma>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Limin,
	Thanks for the report and the patch is already there. Please search the
archive with the subject "ocfs2: Fix oops in fallocate()".

Thanks
Tao
On 04/13/2012 03:58 PM, Chang Limin wrote:
> Hi,
> 
>  Version linux-3.3
> 
> In function
> 
> static long ocfs2_fallocate(struct file *file, int mode, loff_t offset,
> 
>                         loff_t len)
> 
> {
> 
> ?
> 
> return __ocfs2_change_file_space(NULL, inode, offset, cmd,
> &sr,           // file is NULL
> 
>                                         change_size);
> 
> }
> 
>  
> 
> In function
> 
> static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
> 
>                                   loff_t f_pos, unsigned int cmd,
> 
>                                   struct ocfs2_space_resv *sr,
> 
>                                   int change_size)
> 
> {
> 
> if (file->f_flags &
> O_SYNC)                                                                                  
> // access file->f_flags result null pointer
> 
>            handle->h_sync = 1;
> 
> }
> 
>  
> 
> Changlimin
