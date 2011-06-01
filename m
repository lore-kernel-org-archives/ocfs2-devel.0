From: Dan Magenheimer <dan.magenheimer@oracle.com>
Date: Wed, 1 Jun 2011 15:45:48 -0700 (PDT)
Subject: [Ocfs2-devel] bug in cleancache ocfs2 hook,
	anybody want to try cleancache?
Message-ID: <da833bdb-7f77-4ebb-ad9b-9fae656b75a1@default>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com
Cc: Joel Becker <jlbec@evilplan.org>, Steven Whitehouse <swhiteho@redhat.com>, Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org

As Steven Whitehouse points out in this lkml thread:
https://lkml.org/lkml/2011/5/27/221 
there is a bug in the ocfs2 hook to cleancache.
The fix is fairly trivial, but I wonder if anyone
in the ocfs2 community might be interested in trying
out cleancache to author and test the fix?

Currently, the only implementation that benefits from
the sharing functionality is on Xen.

So if you know how to (or are interested in learning
how to) bring up multiple ocfs2 cluster nodes sharing
an ocfs2 filesystem on top of Xen and you are interested
in giving cleancache a spin, please let me know.  Else
I will probably push the fix myself.

Dan

P.S. Links to cleancache info:
http://www.phoronix.com/scan.php?page=news_item&px=OTQ5Mw 
http://lwn.net/Articles/386090/ 
http://blogs.oracle.com/wim/entry/another_feature_hit_mainline_linux 

---

Thanks... for the memory!
I really could use more / my throughput's on the floor
The balloon is flat / my swap disk's fat / I've OOM's in store
Overcommitted so much
(with apologies to Bob Hope)
