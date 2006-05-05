From: Daniel Phillips <phillips@google.com>
Date: Fri, 05 May 2006 11:06:03 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445B32E4.C8CD.0002.0@novell.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
	<20060504223037.GB21588@ca-server1.us.oracle.com> <445AC
	<445B32E4.C8CD.0002.0@novell.com>
Message-ID: <445B940B.80202@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Paul Taysom wrote:
>  The performance you might gain from a separate journaling device will
> be very dependent on exactly how the journal is done.  On NSS, the
> Netware journaled file system, we ran experiments with the journal
> turned off (just didn't do the write) and found it had little impact on
> benchmarks like NetBench.  Part of the reason for this is that the
> journal writes were asynchronous to the main flow of the system.  Normal
> operations would normally not ever wait for journal writes.

That is one load.  Did you try NFS with synchronous mount?

Regards,

Daniel
