From: Andrew Beekhof <abeekhof@suse.de>
Date: Thu Oct 20 06:04:50 2005
Subject: [Ocfs2-devel] [RFC] Integration with external clustering
In-Reply-To: <4356BBE8.2080904@suse.com>
References: <43556F8B.3060105@suse.com>
	<20051018221849.GN11488@ca-server1.us.oracle.com>
	<20051018230323.GE2813@marowsky-bree.de>
	<20051018232752.GO11488@ca-server1.us.oracle.com>
	<20051019132624.GI24589@marowsky-bree.de>
	<4356BBE8.2080904@suse.com>
Message-ID: <C81B7C58-4398-4FA2-B886-FCAE7FF0192B@suse.de>
List-Id: <ocfs2-devel.oss.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ocfs2-devel@oss.oracle.com

I'm kinda new here, so I apologize in advance if I have insulted  
anyone's intelligence below.
My specialty is in hb2 (specifically the CRM) and not yet in OCFS2,  
so I'm also happy to be corrected if I've missed the point or said  
something dumb there too.

Moving on...

On Oct 19, 2005, at 11:34 PM, Jeff Mahoney wrote:


> Lars Marowsky-Bree wrote:
>
>
>> Actually a good point. I don't think the heartbeat hierarchy is  
>> needed
>> if driven by a user-space membership.
>>
>>
>
> If we're to provide membership information on a per file system basis,
> we'll need some way to distinguish between them. The hierarchy may not
> matter in the case of the o2cb global heartbeat, but it does for the
> userspace heartbeat.
>
>
>
>> OCFS2 doesn't register with us in this model; _we_ drive OCFS2 and
>> provide it with the events; we manage it, so we know it's there.
>>
>>
>
> No, OCFS2 needs to register with userspace.
>
> The userspace heart beat should only care about nodes where the file
> system is actually mounted. Otherwise, if a random node that has the
> ability to mount a file system but doesn't actually have it mounted
> could cause heartbeat events across the cluster. That shouldn't  
> happen.
>

I believe the idea here is that "not mounted" == "resource not running"

So like you said, if a node that could but doesn't have the  
filesystem mounted fails... then the filesystem will not hear  
anything about it.

There is also the related point that if it is mounted - we must know  
about it.
Having resources we're supposed to be managing active without us  
knowing is highly evil because it might violate the currently active  
cluster policy.


> In order to do this, I think that at mount time, we should call out to
> user space to tell it to start caring about this node for a particular
> heart beat group. When the file system is umounted, we call out again
> and tell it to stop caring.
>

As I mentioned to Jeff last night, we _could_ make something like  
this work.

However, thinking more about it, I dont think we should.

It seems to me that there are two use cases here and I believe that  
trying to bash one into the form of the other is a mistake.


The first is where the filesystem (often via the user) is in  
control.  Thats where you want mount to work transparently - updating  
the cluster behind the scenes.


The second is where the cluster is in control.  Here a transparent  
mount command is a hinderance because you end up calling back to the  
cluster for no reason or benefit - in fact you end up creating a  
loop.  Not that breaking it isnt possible - but logically it makes no  
sense to create it in the first place.


In case people are wondering why you would even want the cluster to  
be in control... its because it knows more than the filesystem does.

For example the cluster knows that Apache on nodeX failed so we need  
to migrate it (and the filesystem it requires) to nodeY.
Or it might be 7am which means the nighty auditing run is complete  
and we don't need as many nodes to share the load.

In both cases the node is healthy, the filesystem is healthy - but we  
want to stop/move the filesystem anyway.

Alternatively the filesystem may have failed but there are some  
unrelated resources that can/must be safely migrated before the node  
is fenced.


My personal view (others may disagree) is that hb2 resource  
management (the CRM) should stay out of the first scenario.  Use the  
messaging, the membership, or the fencing pieces by all means... but  
not the CRM.
For that situation it doesn't really add anything over what already  
exists and in fact it makes things worse.
Its worse because you now have two brains - both of which want to  
enforce their will on the cluster, both with different policies and  
perspectives.
I don't see how that can ever turn out well.


> Only using the cluster manager to mount or umount a file system  
> isn't an
> acceptable use pattern.
>

I don't think that its an either/or here.  We need to be able to  
support the second scenario without impacting the first.... and then  
let the user decide what fits their needs best.


> OCFS2 shouldn't become so special cased that
> it's a pain to work with. Ideally, it should only be slightly more
> difficult to configure than o2cb is now. mount -t ocfs2 should work  
> with
> no additional effort for the common case. There should be a default
> OCFS2 configuration that we can use for common mounts, and then  
> special
> cased configurations for more advanced topologies. We can pass out the
> UUID as a parameter; I don't think this should be too difficult to do.
>
> - -Jeff
>

--
Andrew Beekhof

"Would the last person to leave please turn out the enlightenment?" -  
TISM
