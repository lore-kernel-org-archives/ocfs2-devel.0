From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Thu, 09 Oct 2014 20:29:00 -0700
Subject: [Ocfs2-devel] Ocfs2-devel Digest, Vol 127, Issue 25
In-Reply-To: <54363EF4.2070901@huawei.com>
References: <71604351584F6A4EBAE558C676F37CA42EC764A5@H3CMLB14-EX.srv.huawei-3com.com>
	<54363EF4.2070901@huawei.com>
Message-ID: <5437527C.2030808@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

On 10/09/2014 12:53 AM, Joseph Qi wrote:
> On 2014/10/9 15:16, Guozhonghua wrote:
>> Hi Joseph and Srinivas,
>>
>> We had merged and test the two patches:
>> 1.    ocfs2: o2net: set tcp user timeout to max value
>>           8e9801dfe37c9e68cdbfcd15988df2187191864e
>> 2.    ocfs2: o2net: don't shutdown connection when idle timeout
>>           c43c363def04cdaed0d9e26dae846081f55714e7
>>
>> They are works well as we shut down and up the Ethernet interface manually and intervals to create the scenarios with shell scripts, the issues cat not be recreated.
>> Thanks you for reviews and better advices.
>>
>> There is another question.
>> As the node number rises to 32 or 128 in one cluster, we think the TCP keep alive MSG interval should be make longer from 2 seconds to 10 seconds and the idle timeout value should be 60000ms or 90000ms.
>> We think it can reduce the non-useful keep alive messages and improve the performance of the TCP connection.
>> O2CB_IDLE_TIMEOUT_MS=30000  to  90000
>> O2CB_KEEPALIVE_DELAY_MS=2000  to  10000
>>
> In my opinion, O2CB_IDLE_TIMEOUT_MS can be changed to suit your scenario.
> But for O2CB_KEEPALIVE_DELAY_MS, I don't think you have to change it.
> It will send keepalive packet only if there is no DLM messages between nodes.
>
>> We test the values and the changes works well.
As Joseph explained they both are tunables, you can run "service o2cb 
configure" to change values. It falls down to how sensitive your 
application want to be to detect network problems.

Can you please elaborate on what you meant by "changes works well". How 
did you test it and what you found ?

>> Is there any side effect? We are forward your better thoughts about that.
>> Thanks.
>>
>> -------------------------------------------------------------------------------------------------------------------------------------
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ????????????????????????????????????????
>> ???
>> This e-mail and its attachments contain confidential information from H3C, which is
>> intended only for the person or entity whose address is listed above. Any use of the
>> information contained herein in any way (including, but not limited to, total or partial
>> disclosure, reproduction, or dissemination) by persons other than the intended
>> recipient(s) is prohibited. If you receive this e-mail in error, please notify the sender
>> by phone or email immediately and delete it!
>>
>
