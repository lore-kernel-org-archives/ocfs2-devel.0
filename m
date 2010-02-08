From: tristan <tristan.ye@oracle.com>
Date: Mon, 08 Feb 2010 09:44:48 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes v1.
In-Reply-To: <20100205231419.GD3416@mail.oracle.com>
References: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
	<4B5CFE12.9010503@oracle.com> <4B5ED495.60001@oracle.com>
	<20100205231419.GD3416@mail.oracle.com>
Message-ID: <4B6F6C90.9010002@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Joel Becker wrote:
> On Tue, Jan 26, 2010 at 07:40:05PM +0800, tristan wrote:
>   
>> Tao Ma wrote:
>> You're absolutely right, as what we expected, the original logic for 
>> truncate was the most efficient one, new method using 
>>     
>
> <snip>
>
>   
>> 1. Original logic:
>> 0.00user 33.06system 0:33.11elapsed 99%CPU
>>
>> 2. New logic(using ocfs2_remove_btree_range) from begin to end:
>> 0.00user 0.35system 0:00.52elapsed 67%CPU
>>
>> 3. New logic(using ocfs2_remove_btree_range) from end to begin:
>> 0.00user 1.15system 0:01.16elapsed 98%CPU
>>
>>
>> Look, method 1 was up to 100 times efficient than method 2, and 3 times 
>> efficient than method 3.
>>     
>
> 	I'm confused.  You state above that the original method was the
> most efficient, yet it took 33 seconds. The remove_btree_range functions
> took .35s and 1.15s.  By that measure the original is the worst.  Or am
> I reading this wrong?
>   

Oh, that's my fault, I misplaced the #1 and #2 logics. original logic 
should be:

0.00user 0.35system 0:00.52elapsed 67%CPU,   while new logic (using ocfs2_remove_btree_range) from begin to end should be:


0.00user 33.06system 0:33.11elapsed 99%CPU.

Sorry for the confusion,

Tristan.


> Joel
>
>   
