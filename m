From: Gang He <ghe@suse.com>
Date: Thu, 16 Nov 2017 19:23:52 -0700
Subject: [Ocfs2-devel] [RFC] make ocfs2/o2net reliable
In-Reply-To: <63ADC13FD55D6546B7DECE290D39E373CED7BB80@H3CMLB14-EX.srv.huawei-3com.com>
References: <63ADC13FD55D6546B7DECE290D39E373CED7B796@H3CMLB14-EX.srv.huawei-3com.com>
	<5A0DD327020000F900098DA7@prv-mh.provo.novell.com>
	<63ADC13FD55D6546B7DECE290D39E373CED7BB80@H3CMLB14-EX.srv.huawei-3com.com>
Message-ID: <5A0EB8B8020000F900098FEA@prv-mh.provo.novell.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com




>>> 
> On 2017/11/16 18:05, Gang He wrote:
>> Hello Changwei,
>> 
>> Base on your description, it looks make sense.
>> Since I uses fs/dlm kernel module, it looks stable.
>> Do you compare both dlm implementation? maybe can learn from each other.
Do you have a detailed steps to reproduce this problem? I think the problem should exist,
Maybe the idea can be referenced by both dlm modules.
Second, if you add this message-id and red-black tree mechanism, you also need to 
add a monitor kernel-thread, to see if these messages in red-black tree will become more and more bigger (this will lead to memory leak).

Thanks
Gang


>> 
>> 
>> Thanks
>> Gang
> 
> Hi Gang,
> Actually , I have studied some code of fs/dlm and I don't think it can 
> handle such a exception scenario. But I don't have a test environment 
> with fs/dlm applied. Can you take some tests like configuring a 
> duplicated IP address to a host.
> I think it is easy to reproduce.
> 
> Thanks,
> Changwei
> 
>> 
>> 
>>>>>
>>> Hi all,
>>> As far as we know, ocfs2/o2net is not a reliable message mechanism.
>>> Messages might get lost due to a sudden TCP socket connection shutdown.
>>> And the only customer of o2net is ocfs2/dlm, so this may cause ocfs2/dlm
>>> hang(missing AST and ASSERT MASTER). Sometimes it also causes
>>> ocfs2/dlm's infinite wait for accomplishment of DLM recovery. But that
>>> won't happen since target node is still heartbeating and no dlm recovery
>>> procedure will be launched.
>>>
>>> So I think above cases drive us to improve current ocfs2/o2net making it
>>> more reliable. I already have a draft design for it. And we indeed need
>>> to change o2net behavior.
>>>
>>> To accomplish this goal, we tag each o2net message with a sequence
>>> ::msg_seq to let receiver tell if the newly coming message is a
>>> duplicated one or not and ::msg_seq will work as a key value for
>>> searching a following key structure in a red-black tree.
>>>
>>> A brandy new structure is added to o2net named as *Message Holder*, it
>>> is responsible for _handle_status_ storing.
>>>
>>> When TCP has to shutdown or reset due to unknown reason, although we
>>> lose the packets in send or receive buffer, o2net still manages those
>>> messages. This gives a chance to o2net to re-send the messages once TCP
>>> connection is established again.
>>>
>>> Below diagram demonstrates how it works:
>>>
>>> SEND					RECV
>>> send message				
>>> tag message header with ::msg_seq	
>>> 					search for Message Holder with
>>> 					  ::msg_seq
>>> 					NOT FOUND - insert one
>>> 					(FOUND - means a duplicated one)
>>> 					handle message
>>> 					store status into Message Holder
>>> 					send back status
>>> instruct RECV to remove MH
>>> 					notify SEND that MH is already
>>> 					  removed
>>> return to caller
>>>
>>> I am expecting your comments especially from @Mark, @Joseph and @Junxiao.
>>>
>>> Thanks,
>>> Changwei.
>>>
>>> _______________________________________________
>>> Ocfs2-devel mailing list
>>> Ocfs2-devel at oss.oracle.com 
>>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel 
>> 
>> 
