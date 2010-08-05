From: Ted Ts'o <tytso@mit.edu>
Date: Thu, 5 Aug 2010 01:42:11 -0400
Subject: [Ocfs2-devel] [PATCH -v2 0/3] jbd2 scalability patches
In-Reply-To: <1280973537.2678.37.camel@localhost.localdomain>
References: <1280939957-3277-1-git-send-email-tytso@mit.edu>
	<1280973537.2678.37.camel@localhost.localdomain>
Message-ID: <20100805054211.GF2901@thunk.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: john stultz <johnstul@us.ibm.com>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, ocfs2-devel@oss.oracle.com, Keith Maanthey <kmannth@us.ibm.com>, Eric Whitney <eric.whitney@hp.com>

Thanks, John, for doing these numbers!!!

> vfs + j_state lock + jdb2 scalability queue
> Throughput 1214.21 MB/sec 8 procs
> Throughput 1175.49 MB/sec 4 procs
> Throughput 716.294 MB/sec 2 procs
> Throughput 402.988 MB/sec 1 procs

2.6.35-rc6-vfs + atomic
Throughput 2648.42 MB/sec 8 procs
Throughput 1586.68 MB/sec 4 procs
Throughput 851.545 MB/sec 2 procs
Throughput 453.106 MB/sec 1 procs

Your earlier numbers were quite a bit higher than this latest set.  I
assume that's due to hardware differences?

					- Ted
