From: Joseph Qi <joseph.qi@linux.alibaba.com>
Date: Thu, 12 Sep 2019 09:06:19 +0800
Subject: [Ocfs2-devel] ocfs2 patches reviewing request
In-Reply-To: <37591f1e-b060-57f2-defc-07a278d308ed@linux.alibaba.com>
References: <37591f1e-b060-57f2-defc-07a278d308ed@linux.alibaba.com>
Message-ID: <1036e9ee-9c02-331f-807c-1fe3de8a4d87@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



On 19/9/11 11:03, Changwei Ge wrote:
> Hi list,
> 
> 
> I have two ocfs2 patches[1] queued in -mm tree for about 5 months.
> 
> Does anyone can help review them?
> 
> Maybe, @Joseph do you have some time?>
Sure, I'll review these two patches ASAP.
Hopefully I can finish it at this weekend.

Thanks,
Joseph
 
> Any comments, advise and questions will be welcomed.
> 
> Hopefully, we can merge them into mainline during next merge window to close the two issues.
> 
> 
> Thanks,
> 
> Changwei
> 
> 
> [1]:
> 
> ocfs2: wait for recovering done after direct unlock request
> 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3D2aaebca745e4cc7c49401374ba1d430ec1fbfe29&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Xjs6wwBtTlH2b26BqOg5CC_cKSyqWW4G1EOa3omCrJ0&s=5TDIRfxDda7paSH28yR-3GvJOr_TUXd9faWUf_cyXM4&e= 
> 
> ocfs2: checkpoint appending truncate log transaction before flushing
> 
> https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3Dabd1a359d33331ae21cf880d579215dc793d925c&d=DwICaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=Xjs6wwBtTlH2b26BqOg5CC_cKSyqWW4G1EOa3omCrJ0&s=cv_91ZWTZ280i8G1sRXMbmASsp_x30YkmEVB_AZCGVo&e= 
