From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Tue, 26 Jan 2010 14:57:35 -0800
Subject: [Ocfs2-devel] dlmglue fixes
In-Reply-To: <20100126163749.GA17656@redhat.com>
References: <1264099803-16680-1-git-send-email-sunil.mushran@oracle.com>
	<20100126123325.GB3845@mail.oracle.com>
	<20100126163749.GA17656@redhat.com>
Message-ID: <4B5F735F.1030905@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

David Teigland wrote:
> I ran http://people.redhat.com/~teigland/make_panic on three nodes for 15
> minutes without any problem, so that's a big improvement.
>
> Then I tried another little test on three nodes which quickly triggered a
> BUG, http://people.redhat.com/~teigland/alternate.c
>
> node1: alternate test 0 0 3
> node2: alternate test 0 1 3
> node3: alternate test 0 2 3
>   

I ran the same on 3 x86 nodes. With o2dlm. It is chugging along.

100324 1114
100327 1062
100330 1289
100333 1131
100336 1142
100339 1222
100342 1233
100345 2941
100348 1228
100351 1141
100354 1070
100357 1197
100360 1159
100363 1223
100366 1220

I'll let it run. I'll also do the same test on a ppc cluster. I've had 
better
luck reproducing such races on that one. Fingers crossed.
