From: Mark Fasheh <mfasheh@suse.com>
Date: Tue, 2 Sep 2008 20:53:41 -0700
Subject: [Ocfs2-devel] [PATCH 1/1] ocfs2: Fix a bug in direct IO read.
In-Reply-To: <1220378234-7298-1-git-send-email-tao.ma@oracle.com>
References: <1220378234-7298-1-git-send-email-tao.ma@oracle.com>
Message-ID: <20080903035341.GE4563@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Wed, Sep 03, 2008 at 01:57:14AM +0800, Tao Ma wrote:
> ocfs2 will become read-only if we try to read the bytes which pass
> the end of i_size. This can be easily reproduced by following steps:
> 1. mkfs a ocfs2 volume with bs=4k cs=4k and nosparse.
> 2. create a small file(say less than 100 bytes) and we will create the file
>    which is allocated 1 cluster.
> 3. read 8196 bytes from the kernel using O_DIRECT which exceeds the limit.
> 4. The ocfs2 volume becomes read-only and dmesg shows:
> OCFS2: ERROR (device sda13): ocfs2_direct_IO_get_blocks:
> Inode 66010 has a hole at block 1> Inode 66010 has a hole at block 1
> File system is now read-only due to the potential of on-disk corruption.
> Please run fsck.ocfs2 once the file system is unmounted.
> 
> So suppress the ERROR message.

Ok, great - thanks Tao.
	--Mark

--
Mark Fasheh
