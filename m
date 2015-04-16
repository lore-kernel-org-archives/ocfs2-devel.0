From: Tariq Saeed <tariq.x.saeed@oracle.com>
Date: Thu, 16 Apr 2015 14:23:52 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2_iop_set/get_acl() are also
 called from the VFS so we must take inode lock
In-Reply-To: <20150416211554.GM17170@wotan.suse.de>
References: <1428097580-25352-1-git-send-email-tariq.x.saeed@oracle.com>
	<1428097580-25352-2-git-send-email-tariq.x.saeed@oracle.com>
	<552F775B.6040203@oracle.com> <553004BD.9020601@oracle.com>
	<20150416211554.GM17170@wotan.suse.de>
Message-ID: <55302868.2040602@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com


On 04/16/2015 02:15 PM, Mark Fasheh wrote:
> change log in those cases is nice.
Sorry, I don't understand what you mean by 'change log'.
I have not seen any message about this patch's -v1 into being
queued for main stream (unless the message is in transit -- very
unlikely!). So, basically, how do I request to discard the first version ...
or is that request implicit in submitting -v2?
Thanks
-Tariq
