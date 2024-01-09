import { serve } from "https://deno.land/std@0.168.0/http/server.ts";

serve(async (req: Request) => {
  const payload = await req.json();
  const newUser = payload.record;
  // const deletedUser = payload.old_record;

  if (!newUser || !newUser.email) {
    return new Response("could not find user/{user.email}");
  }

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${Deno.env.get("RESEND_API_KEY")}`,
    },
    body: JSON.stringify({
      from: "Buzzli <team@mail.buzzli.in>",
      to: [newUser.email],
      subject: "Unlock Your LinkedIn Superpowers with Buzzli",
      html: `<div>
      <p>Hi <strong>${newUser.email}</strong>,</p>

      <p>Welcome aboard the Buzzli express! 🚀</p>

      <p>Thanks for joining us on this exciting journey. Your LinkedIn growth story starts right here, right now!</p>

      <p>Let's dive into some fantastic features waiting for you:</p>

      <ul>
        <li><strong>🌟 Content Inspiration:</strong> Never run out of ideas! Discover trending topics and content suggestions.</li>
        <li><strong>📝 AI-Powered Posts:</strong> Craft captivating LinkedIn content effortlessly with our AI writer.</li>
        <li><strong>🎯 Post Enhancement:</strong> Elevate your existing posts with our AI magic.</li>
        <li><strong>💬 Comment Generator:</strong> Engage better with AI-generated comments for your network.</li>
      </ul>

      <p>But wait, there's more:</p>

      <ul>
        <li><strong>Visualize Your Posts:</strong> See how your content will look on LinkedIn before you hit "Publish."</li>
        <li><strong>Save and Share:</strong> Save your favorite posts and seamlessly share them on LinkedIn.</li>
        <li><strong>Image Library:</strong> Access millions of stunning stock images to enhance your content or even upload your own image.</li>
      </ul>

      <p>We're here to make your LinkedIn experience a breeze! Feel free to explore, create, and grow your LinkedIn presence with Buzzli.</p>

      <p>Enjoy the ride!</p>

      <p>Warm regards, <br>Buzzli Team 🚀</p>
    </div>`,
    }),
  });

  const data = await res.json();

  console.log(`sent email: ${newUser.email} `);

  return new Response(data);
});
