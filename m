From: Joel Becker <jlbec@evilplan.org>
Date: Fri, 21 Jan 2011 17:29:12 +0000
Subject: [Ocfs2-devel] Problems with fsck
In-Reply-To: <4D35D8C7.70905@oracle.com>
References: <4D2DCCF1.4080303@navynet.it> <4D2DD3E0.7080509@oracle.com>
	<4D300363.6080004@tao.ma> <4D30D054.9050804@oracle.com>
	<4D352987.4000904@oracle.com> <4D35D8C7.70905@oracle.com>
Message-ID: <20110121172912.GC8323@ZenIV.linux.org.uk>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Tue, Jan 18, 2011 at 10:15:35AM -0800, Sunil Mushran wrote:
> On 01/17/2011 09:47 PM, Tiger Yang wrote:
> > On 01/15/2011 06:38 AM, Sunil Mushran wrote:
> >> Tiger,
> >> Please can you take these four patches and test enabling indexdirs
> >> on a volume. Please do this ASAP. I want this in the git tree by early
> >> next week.
> > Hi, Sunil,
> >
> > I have finished the testing. If enable indexed-dirs on a volume which has metaecc, tunefs.ocfs2 will get segment fault. Tao's patch fixes this problem.
> 
> Thanks. Add the acks and push them to the git repo.

	Yeah, they all look good.

Joel

-- 
