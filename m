From: Changwei Ge <chge@linux.alibaba.com>
Date: Wed, 11 Sep 2019 11:03:38 +0800
Subject: [Ocfs2-devel] ocfs2 patches reviewing request
Message-ID: <37591f1e-b060-57f2-defc-07a278d308ed@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi list,


I have two ocfs2 patches[1] queued in -mm tree for about 5 months.

Does anyone can help review them?

Maybe, @Joseph do you have some time?

Any comments, advise and questions will be welcomed.

Hopefully, we can merge them into mainline during next merge window to 
close the two issues.


Thanks,

Changwei


[1]:

ocfs2: wait for recovering done after direct unlock request

https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3D2aaebca745e4cc7c49401374ba1d430ec1fbfe29&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=oygHwA9iyu7kfVMsh1RTKlbgy6A9FCW8sum6cdQy5B4&s=34TJQQ9aFTdpVxd4ABm_kdSQ3djpX2m9_7Bhvsj4zWs&e= 

ocfs2: checkpoint appending truncate log transaction before flushing

https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3Dabd1a359d33331ae21cf880d579215dc793d925c&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=oygHwA9iyu7kfVMsh1RTKlbgy6A9FCW8sum6cdQy5B4&s=oiMtLNADvCqtacwGcmpke1Pg59CochFnTwAx4wHJ9hY&e= 
