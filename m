From: Daniel Phillips <phillips@google.com>
Date: Fri, 10 Mar 2006 13:13:23 -0800
Subject: [Ocfs2-devel] Ocfs2 performance
In-Reply-To: <4411C42F.9080908@oracle.com>
References: <4408C2E8.4010600@google.com>	<20060303233617.51718c8e.akpm@osdl.org>	<440B9035.1070404@google.com>	<20060306025800.GA27280@ca-server1.us.oracle.com>	<440BC1C6.1000606@google.com>	<20060306195135.GB27280@ca-server1.us.oracle.com>	<p733bhvgc7f.fsf@verdi.suse.de>	<20060307045835.GF27280@ca-server1.us.oracle.com>	<440FCA81.7090608@google.com>	<20060310002121.GJ27280@ca-server1.us.oracle.com>
	<44116057.5060705@google.com> <4411C42F.9080908@oracle.com>
Message-ID: <4411EBF3.2010007@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zach Brown <zach.brown@oracle.com>
Cc: Mark Fasheh <mark.fasheh@oracle.com>, ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org

Zach Brown wrote:
>>Pretty close race - vmalloc is slightly faster if anything.
> 
> I don't think that test tells us anything interesting about the relative
> load on the TLB.  What would be interesting is seeing the effect
> vmalloc()ed hashes have on a concurrently running load that puts heavy
> pressure on the TLB.

Bzip2 isn't that kind of load?

Regards,

Daniel
