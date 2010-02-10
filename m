From: Sunil Mushran <sunil.mushran@oracle.com>
Date: Wed, 10 Feb 2010 10:37:58 -0800
Subject: [Ocfs2-devel] ocfs2: bug in dlm_process_recovery_data()
In-Reply-To: <20100210100114.GC14210@bicker>
References: <20100209080944.GA13283@bicker> <4B71A0FD.1020708@oracle.com>
	<20100210100114.GC14210@bicker>
Message-ID: <4B72FD06.3050708@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

Dan Carpenter wrote:
> In this case "pos" is "lock" so the code basically is doing this:
> lock = NULL;
> lock = list_entry(lock->member.next, typeof(*lock), member));
>                   ^^^^^^^^^^^^^^^^^
>   

Yes, you are correct. The reason it is working is because the resource
will have only one lock on the list. This is the remastery code. I'll 
fix it.
