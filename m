From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 23 Jun 2009 22:05:37 -0000
Subject: [Ocfs2-devel] [PATCH] fs: Add new pre-allocation ioctls to vfs
	for compatibility with legacy xfs ioctls
In-Reply-To: <20090619182807.GA32683@infradead.org>
References: <4980C71F.1010804@ankitjain.org>
	<20090619182807.GA32683@infradead.org>
Message-ID: <200906200813.59793.arnd@arndb.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch@infradead.org>
Cc: Ankit Jain <me@ankitjain.org>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, mfasheh@suse.com, joel.becker@oracle.com, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org, xfs-masters@oss.sgi.com, xfs@oss.sgi.com

On Friday 19 June 2009 06:28:07 pm Christoph Hellwig wrote:

> +/* on ia32 l_start is on a 32-bit boundary */
> +#if defined(CONFIG_IA64) || defined(CONFIG_X86_64)
> +struct space_resv_32 {
> +	__s16		l_type;
> +	__s16		l_whence;
> +	__s64		l_start	__attribute__((packed));
> +			/* len == 0 means until end of file */
> +	__s64		l_len __attribute__((packed));
> +	__s32		l_sysid;
> +	__u32		l_pid;
> +	__s32		l_pad[4];	/* reserve area */
> +};
> +
> +#define FS_IOC_RESVSP_32		_IOW ('X', 40, struct space_resv_32)
> +#define FS_IOC_RESVSP64_32	_IOW ('X', 42, struct space_resv_32)

I'd just define this using compat_s64 instead of __s64 __packed so we can
use the same code on all architectures, even at the small cost of extra
text size on non-x86 architectures.

> +/* just account for different alignment */
> +static int compat_ioctl_preallocate(struct file *file, unsigned long arg)
> +{
> +	struct space_resv_32	__user *p32 = (void __user *)arg;
> +	struct space_resv	__user *p = compat_alloc_user_space(sizeof(*p));
> +
> +	if (copy_in_user(&p->l_type,	&p32->l_type,	sizeof(s16)) ||
> +	    copy_in_user(&p->l_whence,	&p32->l_whence, sizeof(s16)) ||
> +	    copy_in_user(&p->l_start,	&p32->l_start,	sizeof(s64)) ||
> +	    copy_in_user(&p->l_len,	&p32->l_len,	sizeof(s64)) ||
> +	    copy_in_user(&p->l_sysid,	&p32->l_sysid,	sizeof(s32)) ||
> +	    copy_in_user(&p->l_pid,	&p32->l_pid,	sizeof(u32)) ||
> +	    copy_in_user(&p->l_pad,	&p32->l_pad,	4*sizeof(u32)))
> +		return -EFAULT;
> +
> +	return ioctl_preallocate(file, p);
> +}
> +#endif
> +

Here, you can call do_fallocate directly in the same way that ioctl_preallocate
does, replacing the copy_in_user calls with __get_user().

	Arnd <><
