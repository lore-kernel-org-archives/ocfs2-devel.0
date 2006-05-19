From: J. Bruce Fields <bfields@fieldses.org>
Date: Fri, 19 May 2006 11:16:12 -0400
Subject: [Ocfs2-devel] OCFS2 features RFC
In-Reply-To: <446D12CF.2080501@google.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<446398D3.7010508@suse.com>
	<20060517014419.GS21588@ca-server1.us.oracle.com>
	<446BBCF5.7040903@google.com>
	<20060518024638.GY21588@ca-server1.us.oracle.com>
	<446D12CF.2080501@google.com>
Message-ID: <20060519151612.GF3721@fieldses.org>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On Thu, May 18, 2006 at 05:35:27PM -0700, Daniel Phillips wrote:
> Ok, I just figured out how to be really lazy and do cluster-consistent
> NFS locking across clustered NFS servers without doing much work.  In the
> duh category, only one node will actually run lockd and all other NFS
> server nodes will just port-forward the NLM traffic to/from it.

Yeah, I can't see why that wouldn't work with v2/v3.  The same trick
won't work with NFSv4 since it has the locking integrated into the
protocol.

It shouldn't be that much work to make lockd/nfsd use whatever locking
the filesystem provides--see

http://linux-nfs.org/cgi-bin/gitweb.cgi?p=bfields-2.6.git;a=shortlog;h=server-cluster-locking-api

for one attempt.  Of course the hard part is providing the locking
support in the filesystem in the first place!  And the main obstacle to
our work has been the lack of an in-kernel filesystem that does this....
(The only testing has been done with GPFS.)

--b.
