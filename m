From: john stultz <johnstul@us.ibm.com>
Date: Thu, 05 Aug 2010 10:42:08 -0700
Subject: [Ocfs2-devel] [PATCH -v2 0/3] jbd2 scalability patches
In-Reply-To: <20100805054211.GF2901@thunk.org>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
	<1280973537.2678.37.camel@localhost.localdomain>
	<20100805054211.GF2901@thunk.org>
Message-ID: <1281030128.3405.2.camel@localhost.localdomain>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ted Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>

On Thu, 2010-08-05 at 01:42 -0400, Ted Ts'o wrote:
> Thanks, John, for doing these numbers!!!
> 
> > vfs + j_state lock + jdb2 scalability queue
> > Throughput 1214.21 MB/sec 8 procs
> > Throughput 1175.49 MB/sec 4 procs
> > Throughput 716.294 MB/sec 2 procs
> > Throughput 402.988 MB/sec 1 procs
> 
> 2.6.35-rc6-vfs + atomic
> Throughput 2648.42 MB/sec 8 procs
> Throughput 1586.68 MB/sec 4 procs
> Throughput 851.545 MB/sec 2 procs
> Throughput 453.106 MB/sec 1 procs
> 
> Your earlier numbers were quite a bit higher than this latest set.  I
> assume that's due to hardware differences?

So yes, it was run on a different but similar system.

But the numbers I just provided here were with CONFIG_PREEMPT_RT (vfs:
2.6.33-rt23 or novfs: 2.6.33-rt29). Sorry for not making that explicit.

Do you want me to generate non-rt 2.6.35 numbers as well?

thanks
-john
