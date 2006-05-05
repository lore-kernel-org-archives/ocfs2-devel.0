From: Sunil Mushran <Sunil.Mushran@oracle.com>
Date: Fri, 05 May 2006 11:57:06 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445B32E4.C8CD.0002.0@novell.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>	<445936FE.90401@google.com>
	<44594AE2.9080802@oracle.com>	<44594EC9.3040407@google.com>
	<445A6A61.2090009@oracle.com>	<445A7EF3.2000701@google.com>	<20060504223037.GB21588@ca-server1.us.oracle.com>
	<445AC <445B32E4.C8CD.0002.0@novell.com>
Message-ID: <445BA002.9080909@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

jbd is also asynch. That's not the issue. The issue is more the size of the
journal. The larger the journal, the lesser need to flush the journal.

In ocfs2, as each slot has a separate journal, there is a desire to 
limit the
journal size so as to make more space available to actual data. Also, as the
fs is clustered, flushes could be triggered by other nodes.

So, having a separate device makes sense. It adds complexity to the
configuration, but, that is to be expected. ;)

Paul Taysom wrote:
>  The performance you might gain from a separate journaling device will
> be very dependent on exactly how the journal is done.  On NSS, the
> Netware journaled file system, we ran experiments with the journal
> turned off (just didn't do the write) and found it had little impact on
> benchmarks like NetBench.  Part of the reason for this is that the
> journal writes were asynchronous to the main flow of the system.  Normal
> operations would normally not ever wait for journal writes.
>
> Paul
>  
> _______________________________________________
> Ocfs2- devel mailing list
> Ocfs2- devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2- devel
>
>
> _______________________________________________
> Ocfs2-devel mailing list
> Ocfs2-devel at oss.oracle.com
> http://oss.oracle.com/mailman/listinfo/ocfs2-devel
>   
