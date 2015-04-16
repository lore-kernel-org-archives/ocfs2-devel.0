From: Mark Fasheh <mfasheh@suse.de>
Date: Thu, 16 Apr 2015 14:15:55 -0700
Subject: [Ocfs2-devel] [PATCH 2/2] ocfs2_iop_set/get_acl() are also
 called from the VFS so we must take inode lock
In-Reply-To: <553004BD.9020601@oracle.com>
References: <1428097580-25352-1-git-send-email-tariq.x.saeed@oracle.com>
	<1428097580-25352-2-git-send-email-tariq.x.saeed@oracle.com>
	<552F775B.6040203@oracle.com> <553004BD.9020601@oracle.com>
Message-ID: <20150416211554.GM17170@wotan.suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, Apr 16, 2015 at 11:51:41AM -0700, Tariq Saeed wrote:
> I have no objection to applying your suggestions and re-submitting the
> patch. Mark, what is the protocol for that. Do I need to mention
> that this is a re-sumit?

If you're re-submitting something that hasn't gone upstream yet it's
sufficient to add a 'V2' (or whatever you like) to the subject line. Also, a
change log in those cases is nice.

Thanks,
	--Mark

--
Mark Fasheh
