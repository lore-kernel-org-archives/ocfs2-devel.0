From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Mon, 22 Jun 2009 10:26:54 -0700
Subject: [Ocfs2-devel] [PATCH 5/5] ocfs2: Disable orphan scanning for
 local and hard-ro mounts
In-Reply-To: <20090622161707.GA8805@mail.oracle.com>
References: <1245455599-23348-1-git-send-email-sunil.mushran@oracle.com>
	<1245455599-23348-4-git-send-email-sunil.mushran@oracle.com>
	<20090620044129.GA1993@mail.oracle.com>
	<20090622161707.GA8805@mail.oracle.com>
Message-ID: <4A3FBEDE.10607@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> 	Actually, this lock is only ever taken as EX.  Why is there even
> an ex argument to the function?
>   
Yes, it is not needed. I can't see a need for PR access.
Fix is in testing.
