From: Josef Bacik <josef@redhat.com>
Date: Thu, 31 Mar 2011 18:56:18 -0400
Subject: [Ocfs2-devel] [PATCH 1/3] VFS/ioctl: Add punching-hole support
	to ioctl().
In-Reply-To: <4D94EEC3.2030206@oracle.com>
References: <1301556810-8438-1-git-send-email-tristan.ye@oracle.com>
	<4D94EEC3.2030206@oracle.com>
Message-ID: <20110331225618.GB7484@dhcp231-156.rdu.redhat.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sunil Mushran <sunil.mushran@oracle.com>
Cc: Tristan Ye <tristan.ye@oracle.com>, ocfs2-devel@oss.oracle.com, josef@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, chris.mason@oracle.com, jlbec@evilplan.org, tm@tao.ma

On Thu, Mar 31, 2011 at 02:14:43PM -0700, Sunil Mushran wrote:
> Frankly I see no point extending the ioctl interface when we have
> a syscall interface.
>

I'd even go so far as to say we could probably axe the xfs and ocfs2 ioctls
since we have the fallocate interface :).  Thanks,

Josef
