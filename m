From: Changwei Ge <chge@linux.alibaba.com>
Date: Mon, 16 Sep 2019 11:29:08 +0800
Subject: [Ocfs2-devel] ocfs2 patches reviewing request
In-Reply-To: <5f341d77-b942-af93-2227-3eca115a4148@linux.alibaba.com>
References: <37591f1e-b060-57f2-defc-07a278d308ed@linux.alibaba.com>
	<5f341d77-b942-af93-2227-3eca115a4148@linux.alibaba.com>
Message-ID: <18616125-bbd1-469a-eb9c-4b62a03a911b@linux.alibaba.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joseph,

On 2019/9/15 9:44 ??, Joseph Qi wrote:
> Hi Changwei,
> 
> On 19/9/11 11:03, Changwei Ge wrote:
>> Hi list,
>>
>>
>> I have two ocfs2 patches[1] queued in -mm tree for about 5 months.
>>
>> Does anyone can help review them?
>>
>> Maybe, @Joseph do you have some time?
>>
>> Any comments, advise and questions will be welcomed.
>>
>> Hopefully, we can merge them into mainline during next merge window to close the two issues.
>>
>>
>> Thanks,
>>
>> Changwei
>>
>>
>> [1]:
>>
>> ocfs2: wait for recovering done after direct unlock request
>>
>> https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3D2aaebca745e4cc7c49401374ba1d430ec1fbfe29&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=_t_Of2eXInVn3n8f73nWj6pDN3XgYy0cqf2-rhjXSIo&s=JApCD55Np6-m_ICRyaHBbie44eldDkeLAEBaoAgS0o0&e= 
>>
> I've gone through the thread, it seems that you agreed on a better
> solution after discussed with Jun?

I tried the way as Jun suggested, but after that, IMO, adding a point of 
calculating dlm lock resource usage in 
`dlm_finish_local_lockres_recovery()` might make related code subtle. 
Although Jun's way can run _dlm unlock_ and _dlm recovery_ 
asynchronously, but the issue I reported was a corner case during 
unmounting ocfs2 from different nodes together. So performance should 
not be our biggest concern. A explicit fix would be my preference. 
Practically, most dlm code's behavior is decided after RECOVERING DONE 
if there is recovering process running.



> 
> 
>> ocfs2: checkpoint appending truncate log transaction before flushing
>>
>> https://urldefense.proofpoint.com/v2/url?u=http-3A__git.cmpxchg.org_cgit.cgi_linux-2Dmmotm.git_commit_-3Fh-3Dv5.3-2Drc6-2Dmmotm-2D2019-2D08-2D27-2D20-2D39-26id-3Dabd1a359d33331ae21cf880d579215dc793d925c&d=DwIDaQ&c=RoP1YumCXCgaWHvlZYR8PZh8Bv7qIrMUB65eapI_JnE&r=C7gAd4uDxlAvTdc0vmU6X8CMk6L2iDY8-HD0qT6Fo7Y&m=_t_Of2eXInVn3n8f73nWj6pDN3XgYy0cqf2-rhjXSIo&s=UmlDvPwCLbXPnqDcbXZ_C8ihvRTVwRf3_f_KU5tAksA&e= 
> This looks good to me.
> So should I give my reviewed-by on the original thread, or you'll start a
> new one?

Adding your feedback at my original thread would be fine. :-)

Thanks,
Changwei

> 
> Thanks,
> Joseph
> 
