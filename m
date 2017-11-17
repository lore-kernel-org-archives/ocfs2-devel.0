From: Changwei Ge <ge.changwei@h3c.com>
Date: Fri, 17 Nov 2017 01:38:11 +0000
Subject: [Ocfs2-devel] [RFC] make ocfs2/o2net reliable
References: <63ADC13FD55D6546B7DECE290D39E373CED7B796@H3CMLB14-EX.srv.huawei-3com.com>
	<29954193-08e4-3477-e71b-088abba61049@oracle.com>
Message-ID: <63ADC13FD55D6546B7DECE290D39E373CED7BB35@H3CMLB14-EX.srv.huawei-3com.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Wengang,
Thanks for your comments and inspiration.

On 2017/11/17 7:05, Wengang Wang wrote:
> 
> 
> On 2017/11/16 1:49, Changwei Ge wrote:
>> Hi all,
>> As far as we know, ocfs2/o2net is not a reliable message mechanism.
>> Messages might get lost due to a sudden TCP socket connection shutdown.
>> And the only customer of o2net is ocfs2/dlm, so this may cause ocfs2/dlm
>> hang(missing AST and ASSERT MASTER). Sometimes it also causes
>> ocfs2/dlm's infinite wait for accomplishment of DLM recovery. But that
>> won't happen since target node is still heartbeating and no dlm recovery
>> procedure will be launched.
>>
>> So I think above cases drive us to improve current ocfs2/o2net making it
>> more reliable. I already have a draft design for it. And we indeed need
>> to change o2net behavior.
>>
>> To accomplish this goal, we tag each o2net message with a sequence
>> ::msg_seq to let receiver tell if the newly coming message is a
>> duplicated one or not and ::msg_seq will work as a key value for
>> searching a following key structure in a red-black tree.
>>
>> A brandy new structure is added to o2net named as *Message Holder*, it
>> is responsible for _handle_status_ storing.
>>
>> When TCP has to shutdown or reset due to unknown reason, although we
>> lose the packets in send or receive buffer, o2net still manages those
>> messages. This gives a chance to o2net to re-send the messages once TCP
>> connection is established again.
> This sounds a good idea. some questions.
> 
> So the sender keeps the pending messages (to send) and re-send them when
> necessary.

1.When to keep pending messages:
O2net(in o2net_send_message_vec) fails to get response from  receiver 
but woken up by connection shutdown event(o2net_set_nn_state), then 
o2net will keep pending messages and wait for re-connection established 
again.

2.When to re-send them:
When re-connection establishes, o2net will try to re-send them.

> 
>> Below diagram demonstrates how it works:
>>
>> SEND					RECV
>> send message				
>> tag message header with ::msg_seq	
>> 					search for Message Holder with
>> 					  ::msg_seq
>> 					NOT FOUND - insert one
>> 					(FOUND - means a duplicated one)
>> 					handle message
>> 					store status into Message Holder
>> 					send back status
> I didn't get clear about the receiver's response.
> what if FOUND?? the saved status still apply currently? why?

Um, yes. If the Message Holder is found meaning that this message is a 
duplicated one, so no message handling will be performed but use the 
status stored in Message Holder to respond to sender directly. Otherwise 
the sender might so some overlap work which may cause system bug.

> For example,
> 
> sender sends the message asking which node is the owner of a lock;
> receiver handles the message and the response is node X;
> network issue happened and sender didn't get the response
> The owner of that lock migrated to node X2
> network recovered
> the sender resend the message
> receiver send back it's node X, but actually it's now X2.
> 
> I am quite sure if the above example can happen, but you may need to
> prove the stale status still apply now.
> 
> This is the biggest concern.

I agree with your concern here, the scenario truly exists.
But I suppose the same issue also exists in current o2net/dlm 
implementation.
For example:
1.Sender asks which is the owner of LOCK
2.Receiver finds out it is node X
3.Put the response into TCP send buffer, waiting for TCP layer 
transforming it to sender.
4.owner migrates to node X2
5.Sender still obtains a stale owner. :(

But I think we still have solution for that. Perhaps we need more work 
on o2net customer/application. I am afraid that o2net can hardly solve 
this alone.

> 
> 
>> instruct RECV to remove MH
>> 					notify SEND that MH is already
>> 					  removed
> 
> So another round of network message? What if sending the instrument
> failed due to network issue.

It will try again when a timer expires and again until it makes sure 
that Message Holder has been removed from receiver.

> And this will almost double the network overhead.

I agree, but if we want to make it reliable we have to sacrifice 
something and I think it is worthwhile.

Thanks,
Changwei

> 
> thanks,
> wengang
> 
>> return to caller
>>
>> I am expecting your comments especially from @Mark, @Joseph and @Junxiao.
>>
>> Thanks,
>> Changwei.
>>
>> _______________________________________________
>> Ocfs2-devel mailing list
>> Ocfs2-devel at oss.oracle.com
>> https://oss.oracle.com/mailman/listinfo/ocfs2-devel
> 
> 
