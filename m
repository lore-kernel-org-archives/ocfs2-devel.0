From: Joel Becker <Joel.Becker@oracle.com>
Date: Thu, 7 May 2009 20:10:18 -0700
Subject: [Ocfs2-devel] [RFC] The reflink(2) system call v2.
In-Reply-To: <4A039FF8.7090807@hp.com>
References: <1241331303-23753-1-git-send-email-joel.becker@oracle.com>
	<20090507221535.GA31624@mail.oracle.com> <4A039FF8.7090807@hp.com>
Message-ID: <20090508031018.GB8611@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jim owens <jowens@hp.com>
Cc: jmorris@namei.org, linux-security-module@vger.kernel.org, mtk.manpages@gmail.com, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com, viro@zeniv.linux.org.uk

On Thu, May 07, 2009 at 10:59:04PM -0400, jim owens wrote:
> You certainly did not address:
>
> - desire for one single system call to handle both
>   owner preservation and create with current owner.

	Nope, and I don't intend to.  reflink() is a snapshotting call,
not a kitchen sink.

Joel

-- 

Life's Little Instruction Book #444

	"Never underestimate the power of a kind word or deed."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
