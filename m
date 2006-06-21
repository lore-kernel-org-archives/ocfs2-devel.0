From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Wed, 21 Jun 2006 12:05:21 -0700
Subject: [Ocfs2-devel] OCFS2 and RHEL 4 largesmp kernel?
In-Reply-To: <1150893877.5288.12.camel@brilong-lnx>
References: <1150893877.5288.12.camel@brilong-lnx>
Message-ID: <44999871.4020804@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Yes. We will add that in the build env for 1.2.2.
If you want it for 1.2.1, let me know.

Brian Long wrote:
> Hello,
>
> I was wondering if you plan to compile and or qualify the new "largesmp"
> kernel that Red Hat ships with RHEL 4 Update 3 and beyond?  This is the
> new kernel that supports > 8 x86_64 CPU cores.  Since the changes
> required to support > 8 cores broke the kABI, Red Hat decided to make a
> new RPM called kernel-largesmp.
>
> Thanks for any info.
>
> /Brian/
>   
