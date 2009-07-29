From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 28 Jul 2009 18:39:45 -0700
Subject: [Ocfs2-devel] [PATCH 09/10] Implement quota support for
 disabling SPARSE feature
In-Reply-To: <1248776322-14987-2-git-send-email-jack@suse.cz>
References: <1248776322-14987-1-git-send-email-jack@suse.cz>
	<1248776322-14987-2-git-send-email-jack@suse.cz>
Message-ID: <20090729013945.GF20595@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jul 28, 2009 at 12:18:41PM +0200, Jan Kara wrote:
> When filling holes after disabling SPARSE feature, we have to
> properly update quota information.

I read this as we adjust the quota but don't enforce it.  That is, if
filling a hole will make a user over quota, we allow that to happen.
Right?

Joel

-- 

"You must remember this:
 A kiss is just a kiss,
 A sigh is just a sigh.
 The fundamental rules apply
 As time goes by."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
