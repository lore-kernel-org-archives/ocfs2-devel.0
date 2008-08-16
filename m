From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 16 Aug 2008 17:39:42 +0800
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
Message-ID: <48A6A05E.405@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Mark,
	OK, I will contact Tiger to see whether we can send them out next Monday.

Regards,
Tao

Mark Fasheh wrote:
> On Fri, Aug 15, 2008 at 11:43:06PM +0800, Tao Ma wrote:
>> btw, do you have time to review all the other patches? If yes, I will 
>> wait until you review all of them and send out next round then.
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
> 
> I'll worry about folding follow-up patches back into the main series once
> all review is in. That should free you to concentrate on addressing issues
> as they come up.
> 
> Thanks,
> 	--Mark   (Dusting off his merge-monkey hat)
> 
> --
> Mark Fasheh
