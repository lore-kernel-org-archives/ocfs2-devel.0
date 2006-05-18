From: Daniel Phillips <phillips@google.com>
Date: Thu, 18 May 2006 12:21:29 -0700
Subject: [Ocfs2-devel] Fencing in OCFS2
In-Reply-To: <446CC185.9090306@oracle.com>
References: <c04850370605170720g2ce8d0cayd5328712104fcb21@mail.gmail.com>	<c04850370605180746l531fceb4x3ca1c7d76fef740a@mail.gmail.com>
	<446CC185.9090306@oracle.com>
Message-ID: <446CC939.8060502@google.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Zach Brown wrote:
> Sum Sha wrote:
> 
>>With some experiments and going through OCFS2's quorum code, I am sure
>>that in case of serial split-brain, quorum algorithm will surely break
>>and will cause complete cluster shutdown. It will cause all the
>>subcluster nodes to panic themselves. Please correct me if I am
>>wrong...
> 
> Can you provide the details that lead you to be sure of your analysis?

It seems to be the intended behavior.  No node is a member of a quorum
group so all nodes should be fenced.  This is correct.

What is wrong is the idea that fencing is equivalent to panicking.  No!
Fencing means preventing a particular node from writing to shared storage.
The FAQ item is incorrect.  How about this instead?

Q03     What is fencing?
A03     Fencing is the act of preventing a node from writing to shared
         cluster storage.

Regards,

Daniel
