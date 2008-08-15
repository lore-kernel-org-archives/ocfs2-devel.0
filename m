From: Joel Becker <Joel.Becker@oracle.com>
Date: Fri, 15 Aug 2008 12:18:29 -0700
Subject: [Ocfs2-devel] [PATCH 04/15] Make extend allocation generic.
In-Reply-To: <20080815175942.GU21187@wotan.suse.de>
References: <489A94F4.90903@oracle.com>
	<1218061894-7693-4-git-send-email-tao.ma@oracle.com>
	<20080814200144.GB28875@mail.oracle.com>
	<48A52CDE.4020706@oracle.com>
	<20080814234722.GF17664@mail.oracle.com>
	<48A541D5.2080102@oracle.com>
	<20080815062634.GA28988@mail.oracle.com>
	<48A5A40A.4010004@oracle.com>
	<20080815175942.GU21187@wotan.suse.de>
Message-ID: <20080815191829.GB22815@mail.oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Fri, Aug 15, 2008 at 10:59:42AM -0700, Mark Fasheh wrote:
> On Fri, Aug 15, 2008 at 11:43:06PM +0800, Tao Ma wrote:
> > btw, do you have time to review all the other patches? If yes, I will 
> > wait until you review all of them and send out next round then.
> 
> Can you send the latest stuff, with all fixes that have already been
> discussed up until today, and then address any other issues Joel might find
> in his review as follow-up patches, based on the branch I create in
> ocfs2.git?
> 
> I definitely want whatever review Joel can give, but I also want to get this
> up in ocfs2.git ASAP. Since I'm very confident that the disk format is
> essentially frozen, we can merge more or less immediately and get this stuff
> exposure in the various trees that pick up ocfs2.git.

	I agree with Mark.  If the disk format is frozen - and I trust
you both on that - we want to get exposure more than we want to be
perfect.  Spin what you have and send it out.
	I'm reviewing it so I can understand it :-)  I don't think I
will be able to nail down a timeframe when I'll be done.

Joel

-- 

Dort wo man B?cher verbrennt, verbrennt man am Ende auch Mensch.
(Wherever they burn books, they will also end up burning people.)
	- Heinrich Heine

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker at oracle.com
Phone: (650) 506-8127
