From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 11 Feb 2009 16:19:03 -0800
Subject: [Ocfs2-devel] [PATCH 4/4] ocfs2/dlm: Make
 dlm_assert_master_handler() kill itself instead of the asserter
In-Reply-To: <20090211073515.GD9512@mail.oracle.com>
References: <1233693436-29263-1-git-send-email-sunil.mushran@oracle.com>
	<1233693436-29263-4-git-send-email-sunil.mushran@oracle.com>
	<20090211073515.GD9512@mail.oracle.com>
Message-ID: <49936AF7.50404@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	You mean that the node asserting mastery is probably correct,
> and the node that sees a disconnect between mastery information and the
> asserter is confused?

Yes. It's empirical, ofcourse. This is not easy to trigger. Though
now I have a testcase + env in which I can trigger it more commonly.

The real issue is still there. I am working on it. The reason I want
to push this now is because there are cases when the assertee
kills off multiple asserting nodes.


> 	BUG() isn't much of a die.  Are you figuring soft lockup code
> will eventually kill this?

I've never heard of a BUG() that did not kill a node. Atleast on x86.
Are you sure about this?
