From: Tristan Ye <tristan.ye@oracle.com>
Date: Tue, 07 Dec 2010 09:46:08 +0800
Subject: [Ocfs2-devel] [PATCH 2/3] Ocfs2: Add a new code
 'OCFS2_INFO_FREEINODE' for o2info ioctl.
In-Reply-To: <20101207010746.GM16687@mail.oracle.com>
References: <1289902422-3315-1-git-send-email-tristan.ye@oracle.com>
	<1289902422-3315-3-git-send-email-tristan.ye@oracle.com>
	<20101207010746.GM16687@mail.oracle.com>
Message-ID: <4CFD91E0.7080106@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Nov 16, 2010 at 06:13:41PM +0800, Tristan Ye wrote:
>> +	if (inode_alloc)
>> +		iput(inode_alloc);
>
> 	Do the iput up in the calling function where it matches the
> get_system_file_inode() call.  This just makes it easier to spot the
> get/put pair.

    It makes sense;)

>
> Joel
>
