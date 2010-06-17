From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Thu, 17 Jun 2010 12:31:52 -0700
Subject: [Ocfs2-devel] [PATCH 1/2] ocfs2 fix o2dlm dlm run purgelist
In-Reply-To: <4C1A5393.9080509@oracle.com>
References: <1276663383-8238-1-git-send-email-srinivas.eeda@oracle.com>
	<4C197E0B.1060103@oracle.com>
	<20100617083216.GA17748@mail.oracle.com>
	<4C19DE3E.9080701@oracle.com> <4C1A35C6.1060705@oracle.com>
	<4C1A5393.9080509@oracle.com>
Message-ID: <9A5F3B4B-772E-4A20-8D9D-841C7C783E8C@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

We don't have to update the last used to move it to tail.  If it is  
now in use, means it is about to be taken out of the purgelist. We  
just need to move it from our way for the time being.

On Jun 17, 2010, at 9:55 AM, Srinivas Eeda <srinivas.eeda@oracle.com>  
wrote:

> On 6/17/2010 7:48 AM, Sunil Mushran wrote:
>>
>> On 06/17/2010 01:35 AM, Srinivas Eeda wrote:
>>>
>>> On 6/17/2010 1:32 AM, Joel Becker wrote:
>>>>
>>>> On Wed, Jun 16, 2010 at 06:44:43PM -0700, Sunil Mushran wrote:
>>>>
>>>>> One way to skip a lockres in the purgelist is to list_del_init()  
>>>>> and
>>>>> list_add_tail(). That simplifies the patch a lot.
>>>>>
>>>>> I have attached a quick & dirty patch. See if that satisfies all  
>>>>> the
>>>>> requirements.
>>>>>
>>>>
>>>> 	As far as I can tell from reading the code, the time_after()
>>>> check is because they are time ordered.  Wouldn't moving it to  
>>>> the end
>>>> violate that?
>>>>
>>> right. that's why I didn't want to move used lockres to tail :)
>>
>>
>> No. There is no need for time ordering. Or, am I missing something?
>>
>> We delay the purge incase the file system changes its mind and wants
>> to reuse it. By delaying, we hold onto the mastery information.  
>> That's it.
>>
> So, should we preserve this? or purge the lockres  when it's on  
> purge list? OR we could just update the last_used and move it to end  
> of the list if it can be purged.
