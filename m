From: Tao Ma <tao.ma@oracle.com>
Date: Sat, 06 Feb 2010 08:47:13 +0800
Subject: [Ocfs2-devel] [PATCH 1/1] Ocfs2: Treat ocfs2 truncate as a
 special case of punching holes v1.
In-Reply-To: <20100205231419.GD3416@mail.oracle.com>
References: <1264148107-9341-1-git-send-email-tristan.ye@oracle.com>
	<4B5CFE12.9010503@oracle.com> <4B5ED495.60001@oracle.com>
	<20100205231419.GD3416@mail.oracle.com>
Message-ID: <4B6CBC11.5040801@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Hi Joel,

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
I guess Tristan pasted the wrong numbers here.
The original one is the most efficient since it dive into the b-tree 
internals and no b-tree check up in ocfs2_remove_extent is not necessary.
The 2nd method is Tristan's original v1 patch, he call 
ocfs2_remove_extent from i_size to end, so every time we need to 
rotate_tree_left, so
the performance would be a disaster.
The 3rd method is what I suggest him to change. Although it is not as 
efficient as 1, but it use ocfs2_remove_extent and truncate from the end
to the new i_size.

btw, tristan has pasted the newest patches. I don't know why he didn't 
put a version number in it.
But please have a look at
http://oss.oracle.com/pipermail/ocfs2-devel/2010-February/005864.html
and http://oss.oracle.com/pipermail/ocfs2-devel/2010-February/005863.html
I guess they are ready to go.

Regards,
Tao
