From: Joel Becker <Joel.Becker@oracle.com>
Date: Tue, 25 Nov 2008 09:05:52 -0800
Subject: [Ocfs2-devel] [Patch 1/3] ocfs2-tools: Resolve rpmlint	warnings
	in init scripts
In-Reply-To: <26ef5e70811250035p66a34458kf5ebd0b8d77a594f@mail.gmail.com>
References: <B7D332FF-F786-4DBD-862D-8ED8CCE441A9@suse.de>
	<20081118230312.GB10451@mail.oracle.com>
	<1BC14041-8A8F-40BA-821C-FA838C774CD7@suse.de>
	<20081124221940.GD26470@mail.oracle.com>
	<20081124223046.GE26470@mail.oracle.com>
	<26ef5e70811250035p66a34458kf5ebd0b8d77a594f@mail.gmail.com>
Message-ID: <20081125170552.GB7479@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Nov 25, 2008 at 09:35:11AM +0100, Andrew Beekhof wrote:
> On Mon, Nov 24, 2008 at 23:30, Joel Becker <Joel.Becker@oracle.com> wrote:
> > On Mon, Nov 24, 2008 at 02:19:40PM -0800, Joel Becker wrote:
> >>       rpmlint is wrong here, as it is tracking a SuSE-only behavior.
> >> At least, I can't find a RHEL system that behaves different from LSB.
> >
> >        Actually, rpmlint is always wrong.  An empty -Stop line is valid
> > on sles11 as well - it just means "the same as -Start".
> 
> Ok, just ignore the this patch then.
> I've no personal attachment to them... its just something that the
> SUSE build system threw up and I wanted to be a good OSS citizen by
> submitting it upstream :-)

	Did you see the other part, where I stated we should have
"Required-Stop" match "Required-Stop"?  That's the correct change -
valid for LSB and for SLES11.

Joel

-- 

Life's Little Instruction Book #197

	"Don't forget, a person's greatest emotional need is to 
	 feel appreciated."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
