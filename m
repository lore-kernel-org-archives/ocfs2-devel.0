From: Srinivas Eeda <srinivas.eeda@oracle.com>
Date: Wed, 21 Oct 2015 09:02:19 -0700
Subject: [Ocfs2-devel] OVM: O2CB_HEARTBEAT_THRESHOLD recommended/max
	value
In-Reply-To: <562798C5.3000504@oracle.com>
References: <562798C5.3000504@oracle.com>
Message-ID: <5627B70B.20005@oracle.com>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

which kernel ?

On 10/21/2015 06:53 AM, tomaz kosir wrote:
> Hi All,
>
> cst has ovm crash 2 weeks ago due to network outage. This has been 
> somehow fixed now.
> Now we are searching for some hints how to prevent such issues in the 
> feature.
> What we are thinking about is to increase o2cb timeouts.  If we 
> increase those timeouts to ie. 1h, does this mean we'll have 1hour to 
> fix network outage? Disk are connected directly, we have no issues 
> with that during network outage.
>
> There is interesting note Increase OC2B Cluster Heartbeat Timeout on 
> Exalogic Virtual (Doc ID 1995593.1):
>
>     A detailed step-by-step procedure is provided in this document to
>     increase the O2CB cluster heartbeat timeout from 5 min to a very
>     large value of 24 hr. The increased timeout effectively prevents a
>     catastrophic reboot of all compute nodes on an Exalogic rack in a
>     virtual configuration due to fencing, in the event of ZFS taking a
>     long time to complete a takeover.
>
>
> If O2CB_HEARTBEAT_THRESHOLD and O2CB_IDLE_TIMEOUT_MS are huge, OVS 
> servers will survive long network outage.
> What is much better then to get node crash which couse a lot of work 
> to setup cluster back to working state.
>
> Many thanks,
> Toma?
>
> -- 
> <http://www.oracle.com> Toma? Ko?ir | Principal Technical Account Manager
> Phone: +386 1 5888 876 <tel:+386%201%205888%20876> | Mobile: +386 41 
> 785 517 <tel:+386%2041%20785%20517>
> Oracle Advanced Customer Support
>
> ORACLE Slovenia | Dunajska 156 | 1000 Ljubljana
> <http://www.oracle.com/commitment> Oracle is committed to developing 
> practices and products that help protect the environment

-------------- next part --------------
An HTML attachment was scrubbed...
URL: http://oss.oracle.com/pipermail/ocfs2-devel/attachments/20151021/893bb67d/attachment.html 
