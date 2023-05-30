import SwiftUI

struct ContentView: View {
    
    private let screenWidth: CGFloat = UIScreen.main.bounds.size.width
    private let screenHeight: CGFloat = UIScreen.main.bounds.size.height
    @State private var showBreatheView: Bool = false
    @State private var startAnimation: Bool = false
    @State private var timerCount: CGFloat = 0
    @State private var count: Int = 0
    @State private var breathRate: Int = 7
    @State private var exerciseTime: Int = 1
    @State private var countdownTimer: Int = 60
    @State private var timerTail: Double = 0
    @State private var breatheAction: String = "Nefes Al"
    
    var body: some View{
        ScrollView {
            VStack(spacing: 0){
                Spacer().frame(height: screenHeight * 0.02)
                Text(breatheAction).font(.title).foregroundColor(.black).opacity(showBreatheView ? 1 : 0)
                    .animation(.easeInOut(duration: 0.1), value: breatheAction)
                Spacer().frame(height: screenHeight * 0.08)
                ZStack{
                    ForEach(0...7, id: \.self){ value in
                        Circle()
                            .fill(Color.green.gradient).opacity(0.4)
                            .frame(width: screenHeight * 0.14)
                            .offset(y: startAnimation ? 0 : -screenHeight * 0.07)
                            .rotationEffect(.degrees(Double(value) * 45))
                            .rotationEffect(.degrees(startAnimation ? -45 : 0))
                    }
                }.scaleEffect(startAnimation ? 0.6 : 1)
                    .overlay(content: {
                        Text("\(count == 0 ? Int(Double(30)/Double(breathRate)) : count)").font(.title).fontWeight(.bold).foregroundColor(.white)
                            .opacity(showBreatheView ? 1 : 0).animation(.easeInOut, value: count)
                    })
                Spacer().frame(height: screenHeight * 0.10)
                VStack{
                    HStack{
                        Circle().frame(width: screenWidth * 0.18)
                            .foregroundColor(showBreatheView ? .red : .green).overlay(Button(action: startBreathing){
                                Text(showBreatheView ? "Bitir" : "Başla").foregroundColor(.white)})
                    }
                    Spacer().frame(height: screenHeight * 0.03)
                    ZStack{
                        Rectangle().fill(.green)
                        Text("\(countdownTimer / 60) : "
                             + (countdownTimer % 60 < 10 ? "0" : "")
                             + String(countdownTimer % 60)).font(.title).font(.callout).foregroundColor(.white)
                    }.frame(width: screenWidth * 0.2, height: screenHeight * 0.045)
                    Spacer().frame(height: screenHeight * 0.03)
                }
                HStack{
                    VStack{
                        ZStack{
                            HStack{
                                Spacer().frame(width: screenWidth * 0.04)
                                Rectangle().strokeBorder(.green, lineWidth: 5).background(.green)
                            }
                            HStack{
                                Spacer().frame(width: screenWidth * 0.04)
                                Text("Nefes Hızı").font(.callout).foregroundColor(.white)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                    VStack{
                        HStack{
                            Button(action: {if breathRate > 4 && !showBreatheView {breathRate -= 1}}){
                                Image(systemName: "minus").foregroundColor(.green)
                                    //.symbolVariant(.square.fill).foregroundColor(.green)
                            }
                            ZStack{
                                Circle().fill(.green)
                                Text(String(breathRate)).foregroundColor(.white)
                            }
                            Button(action: {if breathRate < 10 && !showBreatheView {breathRate += 1}}){
                                Image(systemName: "plus").foregroundColor(.green)
                            }
                        }
                    }.frame(maxWidth: screenWidth * 0.25)
                    VStack{
                        ZStack{
                            HStack{
                                Rectangle().strokeBorder(.green, lineWidth: 5).background(.green)
                                Spacer().frame(width: screenWidth * 0.04)
                            }
                            HStack{
                                Text("dakika başı").font(.callout).foregroundColor(.white)
                                Spacer().frame(width: screenWidth * 0.04)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: screenHeight * 0.04)
                Spacer().frame(height: screenHeight * 0.03)
                HStack{
                    VStack{
                        ZStack{
                            HStack{
                                Spacer().frame(width: screenWidth * 0.04)
                                Rectangle().strokeBorder(.green, lineWidth: 5).background(.green)
                            }
                            HStack{
                                Spacer().frame(width: screenWidth * 0.04)
                                Text("Egzersiz Süresi").font(.callout).foregroundColor(.white)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                    VStack{
                        HStack{
                            Button(action: {
                                if exerciseTime > 1 && !showBreatheView {
                                    exerciseTime -= 1
                                    countdownTimer = exerciseTime * 60
                                }
                            }){Image(systemName: "minus").foregroundColor(.green)}
                            ZStack{
                                Circle().fill(.green)
                                Text(String(exerciseTime)).foregroundColor(.white)
                            }
                            Button(action: {
                                if exerciseTime < 5 && !showBreatheView {
                                    exerciseTime += 1
                                    countdownTimer = exerciseTime * 60
                                }
                            }){Image(systemName: "plus").foregroundColor(.green)}
                        }
                    }.frame(maxWidth: screenWidth * 0.25)
                    VStack{
                        ZStack{
                            HStack{
                                Rectangle().strokeBorder(.green, lineWidth: 5).background(.green)
                                Spacer().frame(width: screenWidth * 0.04)
                            }
                            HStack{
                                Text("dakika").font(.callout).foregroundColor(.white)
                                Spacer().frame(width: screenWidth * 0.04)
                            }
                        }
                    }.frame(maxWidth: .infinity)
                }.frame(height: screenHeight * 0.04)
            }.onReceive(Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()){ _ in
                if showBreatheView {
                    if timerCount > Double(30) / Double(breathRate) {
                        timerCount = 0
                        breatheAction = (breatheAction == "Nefes Al" ? "Nefes Ver" : "Nefes Al")
                        withAnimation(.easeInOut(duration: Double(30) / Double(breathRate))){
                            startAnimation.toggle()
                        }
                    }
                    else {
                        timerCount += 0.01
                    }
                    timerTail += 0.01
                    count = Int(((Double(30) / Double(breathRate)) - timerCount))
                    countdownTimer = exerciseTime * 60 - Int(timerTail)
                    if countdownTimer <= 0 {showBreatheView = false}
                }
                else {
                    timerCount = 0
                    timerTail = 0
                    count = 0
                    countdownTimer = exerciseTime * 60
                    breatheAction = "Nefes Al"
                }
            }.onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()){ _ in
                if showBreatheView {
                    countdownTimer -= 1
                }
                else {
                    countdownTimer = exerciseTime * 60
                }
            }
        }
    }
    
    func startBreathing(){
        showBreatheView.toggle()
        if showBreatheView {
            withAnimation(.easeInOut(duration: Double(30) / Double(breathRate))){
                startAnimation = true
            }
        }
        else {
            withAnimation(.easeOut(duration: 0.5)){
                startAnimation = true
                startAnimation = false
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

