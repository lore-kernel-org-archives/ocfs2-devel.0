From: Daniel Phillips <phillips@google.com>
Date: Mon, 08 May 2006 11:22:15 -0700
Subject: [Ocfs2-devel] OCFS2 features RFC - separate journal?
In-Reply-To: <445F32A9.C8CD.0002.0@novell.com>
References: <20060425183553.GB10524@ca-server1.us.oracle.com>
	<445936FE.90401@google.com> <44594AE2.9080802@oracle.com>
	<44594EC9.3040407@google.com> <445A6A61.2090009@oracle.com>
	<445A7EF3.2000701@google.com>
	<20060504223037.GB21588@ca-server1.us.oracle.com> <445AC
	<445F32A9.C8CD.0002.0@novell.com>
Message-ID: <445F8C57.7000501@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Paul Taysom wrote:
> Network Appliance has been very successful with exactly this
> architecture.
> Paul 

Perhaps alternative architectures exist that are just as good, if not
better?

Regards,

Daniel

>>>>Daniel Phillips <phillips@google.com> 05/08/06 11:43 am >>> 
> 
> Paul Taysom wrote:
> 
>>If I was worried about NFS performance, I'd rather use NVRAM as an
>>immediate reply disk drive.
> 
> 
> What makes you think that that is any faster than just having a fast
> journal on the filesystem?  It is certainly messier and adds two more
> data copies.  Plus it only helps NFS, what if there are other servers
> on the node?  And how do you maintain cache consistency with the data
> written to the NFS reply journal when it has been acknowledged but is
> not actually in the filesystem?
> 
> On a snapshot, the NFS reply journal would be one more thing that
> needs to be flushed, this is one more thing needing administration
> attention.
> 
> How much latency do you think is saved by a dedicated reply journal vs
> a fast filesystem journal?  I doubt it is as much as you suppose, it
> is on the order of microseconds per write and the reply journal will
> eventually have to pay double for that anyway.
> 
> Also, somebody has to implement your NFS reply journal, further
> messing
> up knfsd.  I am having a hard time seeing what is good about a
> dedicated NFS reply journal.
> 
> Regards,
> 
> Daniel
> 
