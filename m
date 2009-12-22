From: Tao Ma <tao.ma@oracle.com>
Date: Tue, 22 Dec 2009 10:04:18 +0800
Subject: [Ocfs2-devel] [PATCH] ocfs2/trivial: Add default mask log for
 heartbeat.c
In-Reply-To: <4B3025D5.3040503@oracle.com>
References: <1261375896-11322-1-git-send-email-tao.ma@oracle.com>
	<4B2FF89B.3040101@oracle.com> <4B3022DE.1070006@oracle.com>
	<4B3025D5.3040503@oracle.com>
Message-ID: <4B302922.3000802@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com



Sunil Mushran wrote:
> Tao Ma wrote:
>> Sunil Mushran wrote:
>>> Maybe better if we changed the two mlog(0,... to mlog(ML_HEARTBEAT,...
>>>
>>> Now I don't know why we don't have a default mask in that file but 
>>> instead
>>> have distinct mlogs for HEARTBEAT and HB_BIO. One reason could have 
>>> been to
>>> limit the logging of hb_bio. If that is correct, then adding a 
>>> default mask
>>> will defeat the purpose.
>> yeah, I just got that two mlog(0,...) and tried to find the default 
>> mask and failed. Don't know the real reason for it. Will redo the 
>> patch as you like.
>>
>> But the point I don't get is that why add a default mask will have an 
>> effect on mlog(ML_HB_BIO,...)?
> 
> Reverse. As in, if we make that the default, then the mlogs marked hb_bio
> will also print when we only want heartbeat.
oh, I see. thanks for the explanation.
> 
> Now how does that matter? Probably very little, if at all. But we will be
> revisiting tracing/logging sometime next year. So I would make minimal
> changes in this area right now.
ok, no problem. I will regenerate the patch.

Regards,
Tao
