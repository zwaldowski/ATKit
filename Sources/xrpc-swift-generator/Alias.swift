import ArgumentParser

struct Alias: ExpressibleByArgument {
    
    var pattern: Substring
    var prefix: Substring
    
    init?(argument: String) {
        let parts = argument.split(separator: "=")
        guard parts.count == 2 else { return nil }
        self.pattern = parts[0]
        self.prefix = parts[1]
    }

}
